//
//  SBHHorizontalLine.m
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

#import "SBHHorizontalLine.h"

@implementation SBHHorizontalLine

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] set];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(dirtyRect.origin.x, 2.5)
                              toPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width, 2.5)];
}

@end
