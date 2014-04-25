//
//  SBHViewControllerElementPopoverContentView.m
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

#import "SBHViewControllerElementPopoverContentView.h"

// Shared
#import "StoryboardHelper.h"

// Models
#import "SBHStoryboardCollection.h"
#import "SBHViewControllerElement.h"

NSString * const SBHViewControllerElementPopoverContentViewElementKey = @"SBHViewControllerElementPopoverContentViewElementKey";

NSString * const SBHViewControllerElementPopoverContentViewElementDidSelectNotification = @"SBHViewControllerElementPopoverContentViewRowDidDoubleClickNotification";
NSString * const SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification = @"SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification";

@interface SBHViewControllerElementPopoverContentView ()

- (IBAction)detachPopover:(id)sender;

@end

@implementation SBHViewControllerElementPopoverContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Set default sort order
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"identifier"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)];
    [self.tableView setSortDescriptors:@[sortDescriptor]];
}

- (NSString *)predicateFormat
{
    return @"storyboardIdentifier contains[c] %@";
}

#pragma mark - Actions

- (void)tableViewDidDoubleClick:(id)sender
{
    NSInteger clickedRow = [self.tableView clickedRow];
    
    if (clickedRow >= 0) {
        SBHViewControllerElement *viewControllerElement = [self.sortedElements objectAtIndex:clickedRow];
        
        // Post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:SBHViewControllerElementPopoverContentViewElementDidSelectNotification
                                                            object:self
                                                          userInfo:@{SBHViewControllerElementPopoverContentViewElementKey: viewControllerElement}];
    }
}

- (IBAction)detachPopover:(id)sender
{
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:SBHViewControllerElementPopoverContentViewDetachButtonDidClickNotification
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark - Updating and Drawing the View

- (void)reloadElements
{
    NSMutableArray *elements = [NSMutableArray array];
    
    for (SBHStoryboardCollection *collection in self.collections) {
        [elements addObjectsFromArray:[collection.viewControllerElements allObjects]];
    }
    
    self.elements = elements;
}

#pragma mark - NSTableViewDataSource


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    SBHViewControllerElement *viewControllerElement = [self.sortedElements objectAtIndex:row];
    
    NSString *identifier = tableColumn.identifier;
    
    if ([identifier isEqualToString:@"file"]) {
        return [viewControllerElement.collection.filePath lastPathComponent];
    } else if ([identifier isEqualToString:@"language"]) {
        return viewControllerElement.collection.languageDesignation;
    } else if ([identifier isEqualToString:@"identifier"]) {
        return viewControllerElement.storyboardIdentifier;
    } else if ([identifier isEqualToString:@"customClass"]) {
        return viewControllerElement.customClass;
    } else if ([identifier isEqualToString:@"type"]) {
        return viewControllerElement.typeToString;
    }
    
    return nil;
}

@end
