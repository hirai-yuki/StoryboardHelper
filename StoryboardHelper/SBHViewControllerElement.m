//
//  SBHViewControllerElement.m
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

#import "SBHViewControllerElement.h"

#import "SBHStoryboardCollection.h"

@interface SBHViewControllerElement ()

@property (nonatomic, copy, readwrite) NSString *storyboardIdentifier;

@property (nonatomic, assign, readwrite) SBHViewControllerElementType type;

@property (nonatomic, copy, readwrite) NSString *customClass;

@property (nonatomic, copy, readwrite) NSString *identifier;

@property (nonatomic, weak, readwrite) SBHStoryboardCollection *collection;

@end

@implementation SBHViewControllerElement

+ (instancetype)viewControllerElementWithStoryboardIdentifier:(NSString *)storyboardIdentifier
                                                         type:(SBHViewControllerElementType)type
                                                  customClass:(NSString *)customClass
                                                   identifier:(NSString *)identifier
                                                   collection:(SBHStoryboardCollection *)collection
{
    return [[self alloc] initWithStoryboardIdentifier:storyboardIdentifier
                                       type:type
                                customClass:customClass
                                         identifier:identifier
                                 collection:collection];
}

- (instancetype)initWithStoryboardIdentifier:(NSString *)storyboardIdentifier
                                        type:(SBHViewControllerElementType)type
                                 customClass:(NSString *)customClass
                                  identifier:(NSString *)identifier
                                  collection:(SBHStoryboardCollection *)collection
{
    self = [super init];
    
    if (self) {
        self.storyboardIdentifier = storyboardIdentifier;
        self.type = type;
        self.customClass = customClass;
        self.identifier = identifier;
        
        self.collection = collection;
    }
    
    return self;
}

- (NSString *)typeToString
{
    NSString *typeToString;
    
    switch (self.type) {
        case SBHViewControllerElementTypeViewController:
            typeToString = @"View Controller";
            break;
        case SBHViewControllerElementTypeTableViewController:
            typeToString = @"Table View Controller";
            break;
        case SBHViewControllerElementTypeNavigationController:
            typeToString = @"Navigation Controller";
            break;
        case SBHViewControllerElementTypeTabBarController:
            typeToString = @"Tab Bar Controller";
            break;
        case SBHViewControllerElementTypeCollectionViewController:
            typeToString = @"Collection View Controller";
            break;
        case SBHViewControllerElementTypePageViewController:
            typeToString = @"Page View Controller";
            break;
        case SBHViewControllerElementTypeGLKViewController:
            typeToString = @"GLKit View Controller";
            break;
        case SBHViewControllerElementTypeUnknown:
            typeToString = nil;
            break;
    }
    
    return typeToString;
}

- (NSString *)name
{
    if (self.customClass && self.customClass.length > 0) {
        return self.customClass;
    } else {
        return self.typeToString;
    }
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!object || ![[object class] isEqual:[self class]])
        return NO;
    if (![[self identifier] isEqualToString:[object identifier]])
        return NO;
    
    return YES;
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.storyboardIdentifier hash];
    result = prime * result + self.type;
    result = prime * result + [self.customClass hash];
    result = prime * result + [self.identifier hash];
    result = prime * result + [self.collection hash];
    
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; storyboardIdentifier = %@; type = %@; customClass = %@; identifier = %@; collection = %p>",
            NSStringFromClass([self class]),
            self,
            self.storyboardIdentifier,
            self.typeToString,
            self.customClass,
            self.identifier,
            self.collection
            ];
}

@end
