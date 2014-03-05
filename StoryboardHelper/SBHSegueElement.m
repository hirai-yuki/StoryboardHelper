//
//  SBHStoryboardSegue.m
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

#import "SBHSegueElement.h"

#import "SBHViewControllerElement.h"
#import "SBHStoryboardCollection.h"

@interface SBHSegueElement ()

@property (nonatomic, copy, readwrite) NSString *segueIdentifier;

@property (nonatomic, assign, readwrite) SBHSegueElementKind kind;

@property (nonatomic, copy, readwrite) NSNumber *animates;

@property (nonatomic, copy, readwrite) NSString *modalTransitionStyle;

@property (nonatomic, copy, readwrite) NSString *customClass;

@property (nonatomic, copy, readwrite) NSString *identifier;

@property (nonatomic, weak, readwrite) SBHViewControllerElement *viewControllerElement;

@property (nonatomic, weak, readwrite) SBHStoryboardCollection *collection;

@end

@implementation SBHSegueElement

+ (instancetype)segueElementWithSegueIdentifier:(NSString *)segueIdentifier
                                           kind:(SBHSegueElementKind)kind
                                       animates:(NSNumber *)animates
                           modalTransitionStyle:(NSString *)modalTransitionStyle
                                    customClass:(NSString *)customClass
                                     identifier:(NSString *)identifier
                          viewControllerElement:(SBHViewControllerElement *)viewControllerElement
                                     collection:(SBHStoryboardCollection *)collection
{
    return [[self alloc] initWithSegueIdentifier:segueIdentifier
                                            kind:kind
                                        animates:animates
                            modalTransitionStyle:modalTransitionStyle
                                     customClass:customClass
                                      identifier:identifier
                           viewControllerElement:(SBHViewControllerElement *)viewControllerElement
                                      collection:collection];
}

- (instancetype)initWithSegueIdentifier:(NSString *)segueIdentifier
                                   kind:(SBHSegueElementKind)kind
                               animates:(NSNumber *)animates
                   modalTransitionStyle:(NSString *)modalTransitionStyle
                            customClass:(NSString *)customClass
                             identifier:(NSString *)identifier
                  viewControllerElement:(SBHViewControllerElement *)viewControllerElement
                             collection:(SBHStoryboardCollection *)collection
{
    self = [super init];
    
    if (self) {
        self.segueIdentifier = segueIdentifier;
        self.kind = kind;
        self.animates = animates;
        
        if (modalTransitionStyle && modalTransitionStyle.length > 0) {
            self.modalTransitionStyle = modalTransitionStyle;
        } else {
            self.modalTransitionStyle = @"Default";
        }

        self.customClass = customClass;
        
        self.identifier = identifier;
        
        self.viewControllerElement = viewControllerElement;
        self.collection = collection;
    }
    
    return self;
}

- (NSString *)kindToString
{
    NSString *kindToString;
    
    switch (self.kind) {
        case SBHSegueElementKindPush:
            kindToString = @"Push";
            break;
        case SBHSegueElementKindModal:
            kindToString = @"Modal";
            break;
        case SBHSegueElementKindCustom:
            kindToString = @"Custom";
            break;
        case SBHSegueElementKindUnwind:
            kindToString = @"Unwind";
            break;
        case SBHSegueElementKindUnknown:
            kindToString = nil;
            break;
    }
    
    return kindToString;
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
    
    result = prime * result + [self.segueIdentifier hash];
    result = prime * result + self.kind;
    result = prime * result + [self.animates hash];
    result = prime * result + [self.modalTransitionStyle hash];
    result = prime * result + [self.customClass hash];
    result = prime * result + [self.identifier hash];
    result = prime * result + [self.viewControllerElement hash];
    result = prime * result + [self.collection hash];
    
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; segueIdentifier = %@; kind = %@; animates = %@; modalTransitionStyle = %@; customClass = %@; identifier = %@; viewControllerElement = %p; collection = %p>",
            NSStringFromClass([self class]),
            self,
            self.segueIdentifier,
            self.kindToString,
            self.animates,
            self.modalTransitionStyle,
            self.customClass,
            self.identifier,
            self.viewControllerElement,
            self.collection
            ];
}

@end
