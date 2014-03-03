//
//  SBHRegularExpressionPattern.h
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

@interface SBHRegularExpressionPattern : NSObject

@property (nonatomic, copy, readonly) NSString *pattern;
@property (nonatomic, assign, readonly) NSUInteger numberOfRanges;
@property (nonatomic, assign, readonly) NSUInteger entityRangeIndex;
@property (nonatomic, assign, readonly) NSUInteger keyRangeIndex;

+ (instancetype)patternWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex;

- (instancetype)initWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex;

@end
