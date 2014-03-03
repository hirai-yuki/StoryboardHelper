//
//  SBHPopoverWindowController.m
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

#import "SBHPopoverWindowController.h"

// Views
#import "SBHPopoverWindow.h"

NSString * const SBHPopoverWindowControllerWindowWillCloseNotification = @"SBHPopoverWindowControllerWindowWillCloseNotification";

@implementation SBHPopoverWindowController

- (instancetype)initWithContentViewController:(NSViewController *)contentViewController
{
    SBHPopoverWindow *popoverWindow = [SBHPopoverWindow popoverWindow];
    popoverWindow.delegate = self;
    
    self = [super initWithWindow:popoverWindow];
    
    if (self) {
        self.contentViewController = contentViewController;
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setContentViewController:(NSViewController *)contentViewController
{
    // Remove previous content view
    if (self.contentViewController) {
        [self.contentViewController.view removeFromSuperview];
    }
    
    _contentViewController = contentViewController;
    
    // Set content view of the window
    self.contentViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.window.contentView setFrame:self.contentViewController.view.bounds];
    [self.window.contentView addSubview:self.contentViewController.view];
}


#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:SBHPopoverWindowControllerWindowWillCloseNotification
                                                        object:self
                                                      userInfo:nil];
}

@end
