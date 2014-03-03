//
//  SBHTableCornerView.m
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

#import "SBHTableCornerView.h"

@implementation SBHTableCornerView

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Background
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    // Draw separator
    [[NSColor colorWithDeviceWhite:204.0/255.0 alpha:1.0] setStroke];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(dirtyRect.origin.x, 0.5)
                              toPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width, 0.5)];
}

@end
