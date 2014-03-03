//
//  SBHRegularExpressionPattern.m
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

#import "SBHRegularExpressionPattern.h"

@interface SBHRegularExpressionPattern ()

@property (nonatomic, copy, readwrite) NSString *pattern;
@property (nonatomic, assign, readwrite) NSUInteger numberOfRanges;
@property (nonatomic, assign, readwrite) NSUInteger entityRangeIndex;
@property (nonatomic, assign, readwrite) NSUInteger keyRangeIndex;

@end

@implementation SBHRegularExpressionPattern

+ (instancetype)patternWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex
{
    return [[self alloc] initWithString:string
                         numberOfRanges:numberOfRanges
                       entityRangeIndex:entityRangeIndex
                          keyRangeIndex:keyRangeIndex];
}

- (instancetype)initWithString:(NSString *)string numberOfRanges:(NSUInteger)numberOfRanges entityRangeIndex:(NSUInteger)entityRangeIndex keyRangeIndex:(NSUInteger)keyRangeIndex
{
    self = [super init];
    
    if (self) {
        self.pattern = string;
        self.numberOfRanges = numberOfRanges;
        self.entityRangeIndex = entityRangeIndex;
        self.keyRangeIndex = keyRangeIndex;
    }
    
    return self;
}

@end
