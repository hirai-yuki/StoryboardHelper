//
//  SBHStoryboardSegue.h
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

typedef NS_ENUM(NSUInteger, SBHSegueElementKind) {
    SBHSegueElementKindUnknown = 0,
    SBHSegueElementKindPush,
    SBHSegueElementKindModal,
    SBHSegueElementKindCustom,
};


@class SBHViewControllerElement, SBHStoryboardCollection;

@interface SBHSegueElement : NSObject

@property (nonatomic, copy, readonly) NSString *segueIdentifier;

@property (nonatomic, assign, readonly) SBHSegueElementKind kind;

@property (nonatomic, copy, readonly) NSString *kindToString;

@property (nonatomic, copy, readonly) NSNumber *animates;

@property (nonatomic, copy, readonly) NSString *modalTransitionStyle;

@property (nonatomic, copy, readonly) NSString *customClass;

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, weak, readonly) SBHViewControllerElement *viewControllerElement;

@property (nonatomic, weak, readonly) SBHStoryboardCollection *collection;

+ (instancetype)segueElementWithSegueIdentifier:(NSString *)segueIdentifier
                                           kind:(SBHSegueElementKind)kind
                                       animates:(NSNumber *)animates
                           modalTransitionStyle:(NSString *)modalTransitionStyle
                                    customClass:(NSString *)customClass
                                     identifier:(NSString *)identifier
                          viewControllerElement:(SBHViewControllerElement *)viewControllerElement
                                     collection:(SBHStoryboardCollection *)collection;

- (instancetype)initWithSegueIdentifier:(NSString *)segueIdentifier
                                   kind:(SBHSegueElementKind)kind
                               animates:(NSNumber *)animates
                   modalTransitionStyle:(NSString *)modalTransitionStyle
                            customClass:(NSString *)customClass
                             identifier:(NSString *)identifier
                  viewControllerElement:(SBHViewControllerElement *)viewControllerElement
                             collection:(SBHStoryboardCollection *)collection;


@end
