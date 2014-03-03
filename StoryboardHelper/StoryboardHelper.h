//
//  StoryboardHelper.h
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

#import <Foundation/Foundation.h>

@class IDEIndex;

@interface StoryboardHelper : NSObject

@property (nonatomic, strong, readonly) NSBundle *bundle;

+ (void)pluginDidLoad:(NSBundle *)bundle;
+ (instancetype)sharedPlugin;

- (instancetype)initWithBundle:(NSBundle *)bundle;

- (void)indexNeedsUpdate:(IDEIndex *)index;
- (void)removeStoryboardIdentifiersForIndex:(IDEIndex *)index;

@end
