//
//  SBHViewControllerElement.h
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

typedef NS_ENUM(NSUInteger, SBHViewControllerElementType) {
    SBHViewControllerElementTypeUnknown = 0,
    SBHViewControllerElementTypeViewController,
    SBHViewControllerElementTypeTableViewController,
    SBHViewControllerElementTypeNavigationController,
    SBHViewControllerElementTypeTabBarController,
    SBHViewControllerElementTypeCollectionViewController,
    SBHViewControllerElementTypePageViewController,
    SBHViewControllerElementTypeGLKViewController,
};


@class SBHStoryboardCollection;

@interface SBHViewControllerElement : NSObject

@property (nonatomic, copy, readonly) NSString *storyboardIdentifier;

@property (nonatomic, assign, readonly) SBHViewControllerElementType type;

@property (nonatomic, copy, readonly) NSString *typeToString;

@property (nonatomic, copy, readonly) NSString *customClass;

@property (nonatomic, copy, readonly) NSString *identifier;

@property (nonatomic, weak, readonly) SBHStoryboardCollection *collection;

@property (nonatomic, copy, readonly) NSString *name;

+ (instancetype)viewControllerElementWithStoryboardIdentifier:(NSString *)storyboardIdentifier
                                                         type:(SBHViewControllerElementType)type
                                                  customClass:(NSString *)customClass
                                                   identifier:(NSString *)identifier
                                                   collection:(SBHStoryboardCollection *)collection;

- (instancetype)initWithStoryboardIdentifier:(NSString *)storyboardIdentifier
                                        type:(SBHViewControllerElementType)type
                                 customClass:(NSString *)customClass
                                  identifier:(NSString *)identifier
                                  collection:(SBHStoryboardCollection *)collection;

@end
