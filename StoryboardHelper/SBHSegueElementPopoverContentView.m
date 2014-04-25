//
//  SBHSegueElementPopoverContentView.m
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

#import "SBHSegueElementPopoverContentView.h"

// Shared
#import "StoryboardHelper.h"

// Models
#import "SBHStoryboardCollection.h"
#import "SBHViewControllerElement.h"
#import "SBHSegueElement.h"

NSString * const SBHSegueElementPopoverContentViewElementKey = @"SBHSegueElementPopoverContentViewElementKey";

NSString * const SBHSegueElementPopoverContentViewElementDidSelectNotification = @"SBHSegueElementPopoverContentViewRowDidDoubleClickNotification";
NSString * const SBHSegueElementPopoverContentViewDetachButtonDidClickNotification = @"SBHSegueElementPopoverContentViewDetachButtonDidClickNotification";


@interface SBHSegueElementPopoverContentView ()

- (IBAction)detachPopover:(id)sender;

@end

@implementation SBHSegueElementPopoverContentView

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
    return @"segueIdentifier contains[c] %@";
}

#pragma mark - Actions

- (void)tableViewDidDoubleClick:(id)sender
{
    NSInteger clickedRow = [self.tableView clickedRow];
    
    if (clickedRow >= 0) {
        SBHSegueElement *segueElement = [self.sortedElements objectAtIndex:clickedRow];
        
        // Post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:SBHSegueElementPopoverContentViewElementDidSelectNotification
                                                            object:self
                                                          userInfo:@{SBHSegueElementPopoverContentViewElementKey: segueElement}];
    }
}

- (IBAction)detachPopover:(id)sender
{
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:SBHSegueElementPopoverContentViewDetachButtonDidClickNotification
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark - Updating and Drawing the View

- (void)reloadElements
{
    NSMutableArray *elements = [NSMutableArray array];
    
    for (SBHStoryboardCollection *collection in self.collections) {
        [elements addObjectsFromArray:[collection.segueElements allObjects]];
    }
    
    self.elements = elements;
}

#pragma mark - NSTableViewDataSource


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    SBHSegueElement *segueElement = [self.sortedElements objectAtIndex:row];
    
    NSString *identifier = tableColumn.identifier;
    
    if ([identifier isEqualToString:@"file"]) {
        return [segueElement.collection.filePath lastPathComponent];
    } else if ([identifier isEqualToString:@"language"]) {
        return segueElement.collection.languageDesignation;
    } else if ([identifier isEqualToString:@"identifier"]) {
        return segueElement.segueIdentifier;
    } else if ([identifier isEqualToString:@"viewController"]) {
        return segueElement.viewControllerElement.name;
    } else if ([identifier isEqualToString:@"kind"]) {
        return segueElement.kindToString;
    } else if ([identifier isEqualToString:@"animates"]) {
        if (segueElement.kind == SBHSegueElementKindModal) {
            return (segueElement.animates) ? @"YES" : @"NO";
        } else {
            return @"-";
        }
    } else if ([identifier isEqualToString:@"modalTransitionStyle"]) {
        if (segueElement.kind == SBHSegueElementKindModal) {
            return segueElement.modalTransitionStyle;
        } else {
            return @"-";
        }
    } else if ([identifier isEqualToString:@"customClass"]) {
        if (segueElement.kind == SBHSegueElementKindCustom) {
            return segueElement.customClass;
        } else {
            return @"-";
        }
    }
    
    return nil;
}

@end