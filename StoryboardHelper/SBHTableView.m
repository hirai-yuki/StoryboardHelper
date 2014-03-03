//
//  SBHTableView.m
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

#import "SBHTableView.h"

// Views
#import "SBHTableCornerView.h"
#import "SBHTableHeaderCell.h"

@implementation SBHTableView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Set corner view
    NSView *cornerView = [self cornerView];
    SBHTableCornerView *newCornerView = [[SBHTableCornerView alloc] initWithFrame:cornerView.frame];
    [self setCornerView:newCornerView];
    
    // Change header cell
    for (NSTableColumn *tableColumn in [self tableColumns]) {
        NSTableHeaderCell *headerCell = [tableColumn headerCell];
        
        SBHTableHeaderCell *newHeaderCell = [[SBHTableHeaderCell alloc] init];
        newHeaderCell.tableView = self;
        [newHeaderCell setAttributedStringValue:[headerCell attributedStringValue]];
        
        [tableColumn setHeaderCell:newHeaderCell];
    }
}

@end
