//
//  SBHPopoverContentView.h
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

#import <Cocoa/Cocoa.h>

@interface SBHPopoverContentView : NSView <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet NSTableView *tableView;
@property (nonatomic, weak, readonly) NSButton *detachButton;
@property (nonatomic, copy) NSArray *collections;
@property (nonatomic, copy) NSString *searchString;

@property (nonatomic, copy, readonly) NSString *predicateFormat;
@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, strong) NSMutableArray *sortedElements;

@end
