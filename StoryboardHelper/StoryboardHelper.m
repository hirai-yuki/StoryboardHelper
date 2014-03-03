//
//  StoryboardHelper.m
//  StoryboardHelper
//
//  Created by hirai.yuki on 2014/02/25.
//  Copyright (c) 2014年 hirai.yuki. All rights reserved.
//
//  This plug-in was created in reference to Lin-Xcode5.
//
//  Lin-Xcode5 is:
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
//  (https://github.com/questbeat/Lin-Xcode5)
//

#import "StoryboardHelper.h"

// Xcode
#import "IDEWorkspace.h"
#import "DVTFilePath.h"
#import "IDEIndex.h"
#import "IDEIndexCollection.h"
#import "IDEEditorDocument.h"
#import "IDEWorkspaceWindow.h"
#import "DVTSourceTextView.h"

// Categories
#import "NSBundle+versions.h"

// Shared
#import "SBHUserDefaultsManager.h"

// Models
#import "SBHDetector.h"
#import "SBHEntity.h"
#import "SBHStoryboardCollection.h"
#import "SBHViewControllerElement.h"
#import "SBHSegueElement.h"

// Views
#import "SBHViewControllerElementPopoverContentView.h"
#import "SBHSegueElementPopoverContentView.h"

// Controllers
#import "SBHPopoverWindowController.h"

static StoryboardHelper *_sharedPlugin = nil;

@interface NSPopover ()

- (id)_popoverWindow;

@end

@interface StoryboardHelper () <NSPopoverDelegate>

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) NSPopover *viewControllerElementPopover;
@property (nonatomic, strong) NSPopover *segueElementPopover;
@property (nonatomic, strong) SBHPopoverWindowController *popoverWindowController;
@property (nonatomic, strong) NSViewController *viewControllerElementViewController;
@property (nonatomic, strong) NSViewController *segueElementViewController;

@property (nonatomic, strong) NSTextView *textView;

@property (nonatomic, strong) SBHDetector *detector;
@property (nonatomic, strong) NSMutableDictionary *workspaceStoryboardIdentifiers;
@property (nonatomic, copy) NSString *currentWorkspaceFilePath;
@property (nonatomic, unsafe_unretained) NSResponder *previousFirstResponder;
@property (nonatomic, assign, getter = isActivated) BOOL activated;

@property (nonatomic, strong) NSMenuItem *enableMenuItem;

@end

@implementation StoryboardHelper

+ (void)pluginDidLoad:(NSBundle *)bundle
{
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        _sharedPlugin = [[self alloc] initWithBundle:bundle];
    });
}

+ (instancetype)sharedPlugin
{
    return _sharedPlugin;
}

- (instancetype)init
{
    return [self initWithBundle:nil];
}

- (instancetype)initWithBundle:(NSBundle *)bundle
{
    self = [super init];
    
    if (self) {
        // Initialization
        self.bundle = bundle;
        self.detector = [SBHDetector detector];
        self.workspaceStoryboardIdentifiers = [NSMutableDictionary dictionary];

        // Create menu
        [self createMenuItem];

        // Load views
        [self instantiatePopover];
        [self instantiatePopoverWindowController];
        
        // Register to notification center
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(workspaceWindowDidBecomeMain:)
                                                     name:NSWindowDidBecomeMainNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(indexDidChangeState:)
                                                     name:@"IDEIndexDidChangeStateNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(editorDocumentDidSave:)
                                                     name:@"IDEEditorDocumentDidSaveNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverWindowControllerWindowWillClose:)
                                                     name:SBHPopoverWindowControllerWindowWillCloseNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewViewControllerElementDidSelect:)
                                                     name:SBHViewControllerElementPopoverContentViewElementDidSelectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewDetachButtonDidClick:)
                                                     name:SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewSegueElementDidSelect:)
                                                     name:SBHSegueElementPopoverContentViewElementDidSelectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popoverContentViewDetachButtonDidClick:)
                                                     name:SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(menuDidChange:)
                                                     name:NSMenuDidChangeItemNotification
                                                   object:nil];
        
        // Show the version information
        NSLog(@"StoryboardHelper v%@ was successfully loaded.", [self.bundle shortVersionString]);
        
        // Activate if enabled
        if ([[SBHUserDefaultsManager sharedManager] isEnabled]) {
            [self activate];
        }
    }
    
    return self;
}

- (void)instantiatePopover
{
    NSViewController *viewControllerElementContentViewController = [[NSViewController alloc] initWithNibName:@"SBHViewControllerElementPopoverContentView" bundle:self.bundle];
    
    self.viewControllerElementPopover = [[NSPopover alloc] init];
    self.viewControllerElementPopover.delegate = self;
    self.viewControllerElementPopover.behavior = NSPopoverBehaviorTransient;
    self.viewControllerElementPopover.appearance = NSPopoverAppearanceMinimal;
    self.viewControllerElementPopover.animates = NO;
    self.viewControllerElementPopover.contentViewController = viewControllerElementContentViewController;
    
    self.popover = self.viewControllerElementPopover;
    
    NSViewController *segueElementContentViewController = [[NSViewController alloc] initWithNibName:@"SBHSegueElementPopoverContentView" bundle:self.bundle];
    
    self.segueElementPopover = [[NSPopover alloc] init];
    self.segueElementPopover.delegate = self;
    self.segueElementPopover.behavior = NSPopoverBehaviorTransient;
    self.segueElementPopover.appearance = NSPopoverAppearanceMinimal;
    self.segueElementPopover.animates = NO;
    self.segueElementPopover.contentViewController = segueElementContentViewController;
}

- (void)instantiatePopoverWindowController
{
    self.viewControllerElementViewController = [[NSViewController alloc] initWithNibName:@"SBHViewControllerElementPopoverContentView" bundle:self.bundle];
    SBHViewControllerElementPopoverContentView *viewControllerElementPopoverContentView = (SBHViewControllerElementPopoverContentView *)self.viewControllerElementViewController.view;
    [viewControllerElementPopoverContentView.detachButton setHidden:YES];
    
    self.segueElementViewController = [[NSViewController alloc] initWithNibName:@"SBHSegueElementPopoverContentView" bundle:self.bundle];
    SBHSegueElementPopoverContentView *segueElementPopoverContentView = (SBHSegueElementPopoverContentView *)self.segueElementViewController.view;
    [segueElementPopoverContentView.detachButton setHidden:YES];
    
    SBHPopoverWindowController *popoverWindowController = [[SBHPopoverWindowController alloc] initWithContentViewController:self.viewControllerElementViewController];
    
    self.popoverWindowController = popoverWindowController;
}

- (void)dealloc
{
    // Deactivate
    [self deactivate];
    
    // Remove from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowDidBecomeMainNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEIndexDidChangeStateNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"IDEEditorDocumentDidSaveNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SBHPopoverWindowControllerWindowWillCloseNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SBHViewControllerElementPopoverContentViewElementDidSelectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SBHSegueElementPopoverContentViewElementDidSelectNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSMenuDidChangeItemNotification
                                                  object:nil];
}

#pragma mark - Notifications

- (void)workspaceWindowDidBecomeMain:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:[IDEWorkspaceWindow class]]) {
        NSWindow *workspaceWindow = (NSWindow *)[notification object];
        NSWindowController *workspaceWindowController = (NSWindowController *)workspaceWindow.windowController;
        
        IDEWorkspace *workspace = (IDEWorkspace *)[workspaceWindowController valueForKey:@"_workspace"];
        DVTFilePath *representingFilePath = workspace.representingFilePath;
        NSString *pathString = representingFilePath.pathString;
        
        self.currentWorkspaceFilePath = pathString;
    }
}

- (void)textDidChange:(NSNotification *)notification
{
	if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;
        
        // Find entity
        SBHEntity *entity = [self selectedEntityInTextView:textView];
        
        if (entity) {
            [self presentPopoverInTextView:textView entity:entity];
        } else {
            [self dismissPopover];
        }
	}
}

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
	if ([[notification object] isKindOfClass:[DVTSourceTextView class]]) {
        NSTextView *textView = (NSTextView *)[notification object];
        self.textView = textView;
        
        // Find entity
        SBHEntity *entity = [self selectedEntityInTextView:textView];

        if (entity) {
            [self presentPopoverInTextView:textView entity:entity];
        } else {
            [self dismissPopover];
        }
	}
}

- (void)indexDidChangeState:(NSNotification *)notification
{
    IDEIndex *index = (IDEIndex *)[notification object];
    [self indexNeedsUpdate:index];
}

- (void)menuDidChange:(NSNotification *)notification
{
    // Create menu item
    [self createMenuItem];
}

- (void)editorDocumentDidSave:(NSNotification *)notification
{
    IDEEditorDocument *editorDocument = (IDEEditorDocument *)[notification object];
    DVTFilePath *filePath = editorDocument.filePath;
    NSString *pathString = filePath.pathString;
    
    // Check whether there are any changes to .strings
    NSMutableArray *collections = self.workspaceStoryboardIdentifiers[self.currentWorkspaceFilePath];
    
    for (SBHStoryboardCollection *collection in collections) {
        if ([collection.filePath isEqualToString:pathString]) {
            [collection reloadViewControllerElements];
            
            break;
        }
    }
}

- (void)popoverWindowControllerWindowWillClose:(NSNotification *)notification
{
    // Instantiate popover
    [self instantiatePopover];
}

- (void)popoverContentViewViewControllerElementDidSelect:(NSNotification *)notification
{
    NSTextView *textView = self.textView;
    SBHEntity *entity = [self selectedEntityInTextView:textView];
    
    if (entity) {
        NSArray *selectedRanges = textView.selectedRanges;
        
        if (selectedRanges.count > 0) {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            
            // Locate the key
            NSRange lineRange = [textView.textStorage.string lineRangeForRange:selectedRange];
            NSRange keyRange = NSMakeRange(lineRange.location + entity.keyRange.location, entity.keyRange.length);
            
            // Replace
            SBHViewControllerElement *viewControllerElement = [[notification userInfo] objectForKey:SBHViewControllerElementPopoverContentViewElementKey];
            [textView insertText:viewControllerElement.storyboardIdentifier replacementRange:keyRange];
        }
    }
}

- (void)popoverContentViewSegueElementDidSelect:(NSNotification *)notification
{
    NSTextView *textView = self.textView;
    SBHEntity *entity = [self selectedEntityInTextView:textView];
    
    if (entity) {
        NSArray *selectedRanges = textView.selectedRanges;
        
        if (selectedRanges.count > 0) {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            
            // Locate the key
            NSRange lineRange = [textView.textStorage.string lineRangeForRange:selectedRange];
            NSRange keyRange = NSMakeRange(lineRange.location + entity.keyRange.location, entity.keyRange.length);
            
            // Replace
            SBHSegueElement *segueElement = [[notification userInfo] objectForKey:SBHSegueElementPopoverContentViewElementKey];
            [textView insertText:segueElement.segueIdentifier replacementRange:keyRange];
        }
    }
}

- (void)popoverContentViewAlertDidDismiss:(NSNotification *)notification
{
    // Show popover again
    [self presentPopoverInTextView:self.textView entity:[self selectedEntityInTextView:self.textView]];
}

- (void)popoverContentViewDetachButtonDidClick:(NSNotification *)notification
{
    [self preparePopoverWindow];
    [self detachPopover];
}

#pragma mark - Managing Application State

- (void)activate
{
    if (!self.activated) {
        self.activated = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange:)
                                                     name:NSTextDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChangeSelection:)
                                                     name:NSTextViewDidChangeSelectionNotification
                                                   object:nil];
    }
}

- (void)deactivate
{
    if (self.activated) {
        self.activated = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSTextDidChangeNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSTextViewDidChangeSelectionNotification
                                                      object:nil];
    }
}

#pragma mark - Menu

- (void)createMenuItem
{
    NSMenuItem *editorMenuItem = [[NSApp mainMenu] itemWithTitle:@"Editor"];
    
    if (editorMenuItem && [[editorMenuItem submenu] itemWithTitle:@"StoryboardHelper"] == nil) {
        // Load defaults
        BOOL enabled = [[SBHUserDefaultsManager sharedManager] isEnabled];
        
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"StoryboardHelper" action:NULL keyEquivalent:@""];
        
        NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"StoryboardHelper"];
        menuItem.submenu = submenu;
        
        // Enable StoryboardHelper
        NSMenuItem *enableMenuItem = [[NSMenuItem alloc] initWithTitle:@"Enable StoryboardHelper" action:@selector(toggleEnabled:) keyEquivalent:@""];
        [enableMenuItem setTarget:self];
        enableMenuItem.state = enabled ? NSOnState : NSOffState;
        
        [submenu addItem:enableMenuItem];
        self.enableMenuItem = enableMenuItem;
        
        // Separator
        [submenu addItem:[NSMenuItem separatorItem]];
        
        // Version Info
        NSMenuItem *versionInfoMenuItem = [[NSMenuItem alloc] initWithTitle:@"Version Info" action:@selector(showVersionInfo:) keyEquivalent:@""];
        [versionInfoMenuItem setTarget:self];
        [submenu addItem:versionInfoMenuItem];
        
        [[editorMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        [[editorMenuItem submenu] addItem:menuItem];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    return YES;
}

- (void)toggleEnabled:(id)sender
{
    // Save defaults
    SBHUserDefaultsManager *userDefaultManager = [SBHUserDefaultsManager sharedManager];
    BOOL enabled = ![userDefaultManager isEnabled];
    userDefaultManager.enabled = enabled;
    
    // Update menu item
    self.enableMenuItem.state = enabled ? NSOnState : NSOffState;
    
    // Activate/Deactivate
    if (enabled) {
        [self activate];
    } else {
        [self deactivate];
    }
}

- (void)showVersionInfo:(id)sender
{
    // Create alert
    NSAlert *alert = [NSAlert alertWithMessageText:@"StoryboardHelper"
                                     defaultButton:@"OK"
                                   alternateButton:nil
                                       otherButton:@"Open Website"
                         informativeTextWithFormat:@"Version %@\n\nCopyright (c) 2014 Yuki Hirai\n\nEmail: hirai.yuki@classmethod.jp", [self.bundle shortVersionString]];
    
    // Show alert
    if ([alert runModal] == NSAlertOtherReturn) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://dev.classmethod.jp/author/hirai-yuki/"]];
    }
}

#pragma mark - Index

- (void)indexNeedsUpdate:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;
    
    if (workspaceFilePath) {
        [self updateStoryboardIdentifiersForIndex:index];
    }
}

- (void)updateStoryboardIdentifiersForIndex:(IDEIndex *)index
{
    IDEWorkspace *workspace = [index valueForKey:@"_workspace"];
    DVTFilePath *representingFilePath = workspace.representingFilePath;
    NSString *workspaceFilePath = representingFilePath.pathString;
    
    if (workspaceFilePath) {
        NSString *projectRootPath = [[workspaceFilePath stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
        
        // Find .strings files
        IDEIndexCollection *indexCollection = [index filesContaining:@".storyboard" anchorStart:NO anchorEnd:NO subsequence:NO ignoreCase:YES cancelWhen:nil];
        NSMutableArray *collections = [NSMutableArray array];
        
        for (DVTFilePath *filePath in indexCollection) {
            NSString *pathString = filePath.pathString;
            
            BOOL parseStringsFilesOutsideWorkspaceProject = YES;
            if (parseStringsFilesOutsideWorkspaceProject ||
                (!parseStringsFilesOutsideWorkspaceProject && [pathString rangeOfString:projectRootPath].location != NSNotFound)) {
                // Create storyboardIdentifier collection
                SBHStoryboardCollection *collection = [SBHStoryboardCollection storyboardCollectionWithContentsOfFile:pathString];
                [collections addObject:collection];
            }
        }
        
        [self.workspaceStoryboardIdentifiers setObject:collections forKey:workspaceFilePath];
        
        // Update popover content if current workspace's files changed
        if ([workspaceFilePath isEqualToString:self.currentWorkspaceFilePath]) {
            if ([self.popover isShown]) {
                SBHViewControllerElementPopoverContentView *contentView = (SBHViewControllerElementPopoverContentView *)self.popover.contentViewController.view;
                contentView.collections = collections;
            } else if ([self.popoverWindowController.window isVisible]) {
                SBHViewControllerElementPopoverContentView *contentView = (SBHViewControllerElementPopoverContentView *)self.popoverWindowController.contentViewController.view;
                contentView.collections = collections;
            }
        }
    }
}

- (void)removeStoryboardIdentifiersForIndex:(IDEIndex *)index
{
    DVTFilePath *workspaceFile = index.workspaceFile;
    NSString *workspaceFilePath = workspaceFile.pathString;
    
    if (workspaceFilePath) {
        [self.workspaceStoryboardIdentifiers removeObjectForKey:workspaceFilePath];
    }
}

#pragma mark - Detachig the Popover

- (void)preparePopoverWindow
{
    // Resize popover window
    NSWindow *popoverWindow = [self.popover _popoverWindow];
    
    [self.popoverWindowController.window setFrame:NSMakeRect(popoverWindow.frame.origin.x,
                                                             popoverWindow.frame.origin.y - (80.0 / 2.0),
                                                             self.popover.contentSize.width,
                                                             self.popover.contentSize.height + 80.0)
                                          display:NO];
    
    // Copy popover content
    SBHViewControllerElementPopoverContentView *popoverContentView = (SBHViewControllerElementPopoverContentView *)self.popover.contentViewController.view;
    SBHViewControllerElementPopoverContentView *popoverWindowContentView = (SBHViewControllerElementPopoverContentView *)self.popoverWindowController.contentViewController.view;
    popoverWindowContentView.tableView.sortDescriptors = popoverContentView.tableView.sortDescriptors;
    popoverWindowContentView.collections = popoverContentView.collections;
    popoverWindowContentView.searchString = popoverContentView.searchString;
}

- (void)detachPopover
{
    [self dismissPopover];
    [self.popoverWindowController showWindow:nil];
}


#pragma mark - Entity

- (SBHEntity *)selectedEntityInTextView:(NSTextView *)textView
{
    NSArray *selectedRanges = textView.selectedRanges;
    
    if (selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        
        // Locate the line containing the caret
        NSString *string = textView.textStorage.string;
        NSRange lineRange = [string lineRangeForRange:selectedRange];
        NSString *lineString = [string substringWithRange:lineRange];
        NSRange selectedRangeInLine = NSMakeRange(selectedRange.location - lineRange.location, selectedRange.length);
        
        // Search for the entities
        NSArray *entities = [self.detector entitiesInString:lineString];
        
        for (SBHEntity *entity in entities) {
            if (NSLocationInRange(selectedRangeInLine.location, entity.entityRange)) {
                return entity;
            }
        }
    }
    
    return nil;
}

#pragma mark - Popover

- (void)presentPopoverInTextView:(NSTextView *)textView entity:(SBHEntity *)entity
{
    if (![[SBHUserDefaultsManager sharedManager] isEnabled]) {
        return;
    }
    
    NSArray *selectedRanges = textView.selectedRanges;
    
    if (selectedRanges.count > 0) {
        NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
        
        // Locate the line containing the caret
        NSRange lineRange = [textView.textStorage.string lineRangeForRange:selectedRange];
        
        // Stick popover at the beginning of the key
        NSRange keyRange = NSMakeRange(lineRange.location + entity.keyRange.location, 1);
        NSRect keyRectOnScreen = [textView firstRectForCharacterRange:keyRange];
        NSRect keyRectOnWindow = [textView.window convertRectFromScreen:keyRectOnScreen];
        NSRect keyRectOnTextView = [textView convertRect:keyRectOnWindow fromView:nil];
        
        // Update or show popover
        NSArray *collections = [self.workspaceStoryboardIdentifiers objectForKey:self.currentWorkspaceFilePath];
        NSString *key = [textView.textStorage.string substringWithRange:NSMakeRange(lineRange.location + entity.keyRange.location, entity.keyRange.length)];
        
        switch (entity.type) {
            case SBHEntityTypeInstantiateViewControllerWithIdentifier:
                self.popoverWindowController.contentViewController = self.viewControllerElementViewController;
                self.popover = self.viewControllerElementPopover;
                break;
                
            case SBHEntityTypePerformSegueWithIdentifier:
            case SBHEntityTypeSegueIdentifierComparison:
                self.popoverWindowController.contentViewController = self.segueElementViewController;
                self.popover = self.segueElementPopover;
                break;
        }
        
        if ([self.popoverWindowController.window isVisible]) {
            // Update popover content
            SBHPopoverContentView *contentView = (SBHPopoverContentView *)self.popoverWindowController.contentViewController.view;
            contentView.collections = collections;
            contentView.searchString = key;
        } else {
            if ([self.popover isShown]) {
                // Update the position for popover when the cursor moved
                self.popover.positioningRect = keyRectOnTextView;
                
                // Update popover content
                SBHPopoverContentView *contentView = (SBHPopoverContentView *)self.popover.contentViewController.view;
                contentView.searchString = key;
            } else {
                // Show popover
                [self.popover showRelativeToRect:keyRectOnTextView
                                          ofView:textView
                                   preferredEdge:NSMinYEdge];
                
                // Update popover content
                SBHPopoverContentView *contentView = (SBHPopoverContentView *)self.popover.contentViewController.view;
                contentView.collections = collections;
                contentView.searchString = key;
            }
        }
    }
}

- (void)dismissPopover
{
    if ([self.popoverWindowController.window isVisible]) {
        // Update popover content
        NSArray *collections = [self.workspaceStoryboardIdentifiers objectForKey:self.currentWorkspaceFilePath];
        
        SBHPopoverContentView *contentView = (SBHPopoverContentView *)self.popoverWindowController.contentViewController.view;
        contentView.collections = collections;
        contentView.searchString = nil;
    } else {
        // Hide popover
        if (self.popover.shown) {
            [self.popover performClose:self];
        }
    }
}

#pragma mark - NSPopoverDelegate

- (void)popoverWillShow:(NSNotification *)notification
{
    // Save first responder
    self.previousFirstResponder = [self.textView.window firstResponder];
}

- (void)popoverDidShow:(NSNotification *)notification
{
    // Reclaim key window and first responder
    [self.textView.window becomeKeyWindow];
    [self.textView.window makeFirstResponder:self.previousFirstResponder];
}

- (NSWindow *)detachableWindowForPopover:(NSPopover *)popover
{
    // Prepare for detaching
    [self preparePopoverWindow];
    
    return self.popoverWindowController.window;
}

@end
