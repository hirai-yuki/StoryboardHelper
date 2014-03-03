//
//  SBHStoryboardCollection.h
//  StoryboardHelper
//
//  Created by Tanaka Katsuma on 2013/08/21.
//  Copyright (c) 2013年 Tanaka Katsuma. All rights reserved.
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

@class SBHViewControllerElement;

@interface SBHStoryboardCollection : NSObject

@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *languageDesignation;

@property (nonatomic, strong, readonly) NSMutableSet *viewControllerElements;
@property (nonatomic, strong, readonly) NSMutableSet *segueElements;

+ (instancetype)storyboardCollectionWithContentsOfFile:(NSString *)filePath;

- (instancetype)initWithContentsOfFile:(NSString *)filePath;

- (NSString *)fileName;

- (void)reloadViewControllerElements;

@end
