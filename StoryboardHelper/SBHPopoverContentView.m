//
//  SBHPopoverContentView.m
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

#import "SBHPopoverContentView.h"

// Shared
#import "StoryboardHelper.h"

// Models
#import "SBHStoryboardCollection.h"

// Views
#import "SBHTableHeaderCell.h"

@implementation SBHPopoverContentView

#pragma mark - Accessors

- (void)setTableView:(NSTableView *)tableView
{
    _tableView = tableView;
    
    // Set double click action
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(tableViewDidDoubleClick:)];
}

- (void)setCollections:(NSArray *)collections
{
    _collections = collections;
    
    // Update
    [self configureView];
}

- (void)setSearchString:(NSString *)searchString
{
    _searchString = searchString;
    
    // Update
    [self configureView];
}

#pragma mark - Actions

- (void)tableViewDidDoubleClick:(id)sender
{
    // subclass
}

#pragma mark - Updating and Drawing the View

- (void)reloadElements
{
    // subclass
}

- (void)filterElements
{
    // Filter elements
    NSArray *filteredElements = self.elements;
    
    if (self.searchString.length > 0) {
        filteredElements = [filteredElements filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:self.predicateFormat, self.searchString]];
    }
    
    // Sort elements
    self.sortedElements = [[filteredElements sortedArrayUsingDescriptors:self.tableView.sortDescriptors] mutableCopy];
}

- (void)configureView
{
    // Reload elements
    [self reloadElements];
    
    // Filter elements
    [self filterElements];
    
    // Update table view
    [self.tableView reloadData];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.sortedElements.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    // subclass
    return nil;
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    // Update
    [self configureView];
}

#pragma mark - NSTableViewDelegate

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)clickedTableColumn
{
    for (NSTableColumn *tableColumn in [tableView tableColumns]) {
        SBHTableHeaderCell *headerCell = (SBHTableHeaderCell*)[tableColumn headerCell];
        
        if (tableColumn == clickedTableColumn) {
            [headerCell setSortAscending:[[[tableView sortDescriptors] objectAtIndex:0] ascending]
                                priority:0];
        } else {
            [headerCell setSortAscending:NO
                                priority:1];
        }
    }
}

@end
