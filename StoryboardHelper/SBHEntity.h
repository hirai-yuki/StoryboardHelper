//
//  SBHEntity.h
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

typedef NS_ENUM(NSUInteger, SBHEntityType) {
    SBHEntityTypeInstantiateViewControllerWithIdentifier = 0,
    SBHEntityTypePerformSegueWithIdentifier,
    SBHEntityTypeSegueIdentifierComparison
};


NS_INLINE NSString * NSStringFromEntityType(SBHEntityType type) {
    NSString *string = nil;
    
    switch (type) {
        case SBHEntityTypeInstantiateViewControllerWithIdentifier:
            string = @"SBHEntityTypeInstantiateViewControllerWithIdentifier";
            break;
        case SBHEntityTypePerformSegueWithIdentifier:
            string = @"SBHEntityTypePerformSegueWithIdentifier";
            break;
        case SBHEntityTypeSegueIdentifierComparison:
            string = @"SBHEntityTypeSegueIdentifierComparison";
            break;
    }
    
    return string;
}

@interface SBHEntity : NSObject

@property (nonatomic, assign, readonly) SBHEntityType type;
@property (nonatomic, assign, readonly) NSRange entityRange;
@property (nonatomic, assign, readonly) NSRange keyRange;

+ (instancetype)entityWithType:(SBHEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange;

- (instancetype)initWithType:(SBHEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange;

@end
