//
//  SBHDetector.m
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

#import "SBHDetector.h"

// Models
#import "SBHEntity.h"
#import "SBHRegularExpressionPattern.h"
#import "SBHRegularExpressionPattern+type.h"

@interface SBHDetector ()

@property (nonatomic, copy, readwrite) NSArray *regularExpressionPatterns;

@end

@implementation SBHDetector

+ (instancetype)detector
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.regularExpressionPatterns = @[
                                           [SBHRegularExpressionPattern patternWithType:SBHEntityTypeInstantiateViewControllerWithIdentifier],
                                           [SBHRegularExpressionPattern patternWithType:SBHEntityTypePerformSegueWithIdentifier],
                                           [SBHRegularExpressionPattern patternWithType:SBHEntityTypeSegueIdentifierComparison]
                                           ];
    }
    
    return self;
}


#pragma mark - Finding Entities

- (NSArray *)entitiesInString:(NSString *)string
{
    NSMutableArray *entities = [NSMutableArray array];
    
    for (SBHRegularExpressionPattern *regularExpressionPattern in self.regularExpressionPatterns) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern.pattern options:0 error:NULL];
        
        __block NSRange entityRange;
        __block NSRange keyRange;
        
        [regularExpression enumerateMatchesInString:string
                                            options:0
                                              range:NSMakeRange(0, string.length)
                                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                             if (result.numberOfRanges == regularExpressionPattern.numberOfRanges) {
                                                 entityRange = [result rangeAtIndex:regularExpressionPattern.entityRangeIndex];
                                                 keyRange = [result rangeAtIndex:regularExpressionPattern.keyRangeIndex];
                                                 
                                                 SBHEntity *entity = [SBHEntity entityWithType:regularExpressionPattern.type
                                                                                 entityRange:entityRange
                                                                                    keyRange:keyRange];
                                                 
                                                 [entities addObject:entity];
                                             }
                                         }];
    }
    
    return [entities copy];
}

@end
