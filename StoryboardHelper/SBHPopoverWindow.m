//
//  SBHPopoverWindow.m
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

#import "SBHPopoverWindow.h"

// Views
#import "SBHViewControllerElementPopoverContentView.h"

// Controllers
#import "SBHPopoverWindowController.h"

static NSString * const kSBHPopoverWindowToolbarSearchFieldIdentifier = @"Search";

@interface SBHPopoverWindow ()

@property (nonatomic, strong) NSSearchField *searchField;

@end

@implementation SBHPopoverWindow

+ (instancetype)popoverWindow
{
    SBHPopoverWindow *popoverWindow = [[SBHPopoverWindow alloc] initWithContentRect:NSZeroRect
                                                                        styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask)
                                                                          backing:NSBackingStoreBuffered
                                                                            defer:NO];
    popoverWindow.title = @"StoryboardHelper";
    popoverWindow.level = NSFloatingWindowLevel;
    popoverWindow.backgroundColor = [NSColor whiteColor];
    [popoverWindow.contentView setAutoresizesSubviews:YES];
    
    return popoverWindow;
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    if (self) {
        // Create toolbar
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Toolbar"];
        toolbar.delegate = self;
        toolbar.displayMode = NSToolbarDisplayModeIconOnly;
        
        [self setToolbar:toolbar];
    }
    
    return self;
}


#pragma mark - Actions

- (void)textFieldDidReturn:(id)sender
{
    [self controlTextDidChange:nil];
}


#pragma mark - NSToolbarDelegate

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier, kSBHPopoverWindowToolbarSearchFieldIdentifier];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier, kSBHPopoverWindowToolbarSearchFieldIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = nil;
    
    if ([itemIdentifier isEqualToString:kSBHPopoverWindowToolbarSearchFieldIdentifier]) {
        toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        
        NSSearchField *searchField = [[NSSearchField alloc] init];
        [searchField setDelegate:self];
        [searchField setTarget:self];
        [searchField setAction:@selector(textFieldDidReturn:)];
        
        [toolbarItem setView:searchField];
        self.searchField = searchField;
    }
    
    return toolbarItem;
}


#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    SBHPopoverWindowController *popoverWindowController = (SBHPopoverWindowController *)self.windowController;
    SBHViewControllerElementPopoverContentView *contentView = (SBHViewControllerElementPopoverContentView *)popoverWindowController.contentViewController.view;
    
    contentView.searchString = self.searchField.stringValue;
}

@end
