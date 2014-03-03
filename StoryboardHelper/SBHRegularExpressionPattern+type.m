//
//  SBHRegularExpressionPattern+type.m
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

#import "SBHRegularExpressionPattern+type.h"
#import <objc/runtime.h>

static NSString * const SBHRegularExpressionPatternTypePropertyKey = @"type";

@implementation SBHRegularExpressionPattern (type)

- (SBHEntityType)type
{
    return [objc_getAssociatedObject(self, (__bridge const void *)(SBHRegularExpressionPatternTypePropertyKey)) unsignedIntegerValue];
}

- (void)setType:(SBHEntityType)type
{
    objc_setAssociatedObject(self, (__bridge const void *)(SBHRegularExpressionPatternTypePropertyKey), @(type), OBJC_ASSOCIATION_ASSIGN);
}

+ (instancetype)patternWithType:(SBHEntityType)type
{
    SBHRegularExpressionPattern *regularExpression = nil;
    
    NSString *pettern = nil;
    NSUInteger numberOfRanges = 0;
    NSUInteger entityRangeIndex = 0;
    NSUInteger keyRangeIndex = 1;
    
    switch (type) {
        case SBHEntityTypeInstantiateViewControllerWithIdentifier:
        {
            pettern = @"instantiateViewControllerWithIdentifier:\\s*@\"(.*?)\"";
            numberOfRanges = 2;
        }
            break;
        case SBHEntityTypePerformSegueWithIdentifier:
        {
            pettern = @"performSegueWithIdentifier:\\s*@\"(.*?)\"\\s*sender:\\s*(.*?)";
            numberOfRanges = 3;
        }
            break;
        case SBHEntityTypeSegueIdentifierComparison:
        {
            pettern = @"segue.identifier\\s*isEqualToString:\\s*@\"(.*?)\"";
            numberOfRanges = 2;
        }
            break;
    }
    
    if (pettern) {
        regularExpression = [SBHRegularExpressionPattern patternWithString:pettern
                                                            numberOfRanges:numberOfRanges
                                                          entityRangeIndex:entityRangeIndex
                                                             keyRangeIndex:keyRangeIndex];
        regularExpression.type = type;
    }
    
    return regularExpression;
}

@end
