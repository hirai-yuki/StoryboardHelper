//
//  SBHTableHeaderCell.m
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

#import "SBHTableHeaderCell.h"

static const NSInteger kSBHTableHeaderCellSortIndicatorWidth = 8;
static const NSInteger kSBHTableHeaderCellSortIndicatorHeight = 7;
static const NSInteger kSBHTableHeaderCellSortIndicatorMarginX = 4;
static const NSInteger kSBHTableHeaderCellSortIndicatorMarginY = 6;

@interface SBHTableHeaderCell ()

@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, assign) NSInteger priority;

- (void)drawContentInRect:(NSRect)rect highlighted:(BOOL)highlighted;

@end

@implementation SBHTableHeaderCell

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.priority = 1;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority
{
    self.ascending = ascending;
    self.priority = priority;
}


#pragma mark - Drawing the View

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawContentInRect:cellFrame highlighted:NO];
    [self drawSortIndicatorWithFrame:cellFrame inView:controlView ascending:self.ascending priority:self.priority];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self drawContentInRect:cellFrame highlighted:YES];
    [self drawSortIndicatorWithFrame:cellFrame inView:controlView ascending:self.ascending priority:self.priority];
}

- (void)drawContentInRect:(NSRect)rect highlighted:(BOOL)highlighted
{
    // Draw background
    NSRect backgroundRect = rect;
    backgroundRect.size.width -= 1;
    
    if (highlighted) {
        [[NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0] set];
    } else {
        [[NSColor whiteColor] set];
    }
    
    NSRectFill(backgroundRect);
    
    // Draw separator
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] setStroke];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(rect.origin.x, rect.size.height - 0.5)
                              toPoint:NSMakePoint(rect.origin.x + rect.size.width, rect.size.height - 0.5)];
    
    // Draw title
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
    
    NSDictionary *attributes;
    if (highlighted) {
        attributes = @{
                       NSForegroundColorAttributeName: [NSColor whiteColor],
                       NSFontAttributeName: [NSFont systemFontOfSize:12.0]
                       };
    } else {
        attributes = @{
                       NSForegroundColorAttributeName: [NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0],
                       NSFontAttributeName: [NSFont systemFontOfSize:12.0]
                       };
    }
    
    [attributedString addAttributes:attributes range:NSMakeRange(0, [attributedString length])];
    
    NSRect titleRect = rect;
    titleRect.origin.x += 3;
    titleRect.origin.y += 0;
    
    [attributedString drawInRect:titleRect];
}

- (void)drawSortIndicatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView ascending:(BOOL)ascending priority:(NSInteger)priority
{
    NSBezierPath *path = [NSBezierPath bezierPath];
    
    if (ascending) {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - kSBHTableHeaderCellSortIndicatorWidth - kSBHTableHeaderCellSortIndicatorMarginX,
                                cellFrame.origin.y + cellFrame.size.height - kSBHTableHeaderCellSortIndicatorMarginY);
        [path moveToPoint:p];
        
        p.x += kSBHTableHeaderCellSortIndicatorWidth / 2.0;
        p.y -= kSBHTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
        
        p.x += kSBHTableHeaderCellSortIndicatorWidth / 2.0;
        p.y += kSBHTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
    } else {
        NSPoint p = NSMakePoint(cellFrame.origin.x + cellFrame.size.width - kSBHTableHeaderCellSortIndicatorWidth - kSBHTableHeaderCellSortIndicatorMarginX,
                                cellFrame.origin.y + cellFrame.size.height - kSBHTableHeaderCellSortIndicatorHeight - kSBHTableHeaderCellSortIndicatorMarginY);
        [path moveToPoint:p];
        
        p.x += kSBHTableHeaderCellSortIndicatorWidth / 2.0;
        p.y += kSBHTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
        
        p.x += kSBHTableHeaderCellSortIndicatorWidth / 2.0;
        p.y -= kSBHTableHeaderCellSortIndicatorHeight;
        [path lineToPoint:p];
    }
    
    [path closePath];
    
    if (priority == 0) {
        [[NSColor colorWithDeviceWhite:153.0/255.0 alpha:1.0] set];
    } else {
        [[NSColor clearColor] set];
    }
    
    [path fill];
}

@end
