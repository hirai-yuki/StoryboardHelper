//
//  SBHEntity.m
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

#import "SBHEntity.h"

@interface SBHEntity ()

@property (nonatomic, assign, readwrite) SBHEntityType type;
@property (nonatomic, assign, readwrite) NSRange entityRange;
@property (nonatomic, assign, readwrite) NSRange keyRange;

@end

@implementation SBHEntity

+ (instancetype)entityWithType:(SBHEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange
{
    return [[self alloc] initWithType:type entityRange:entityRange keyRange:keyRange];
}

- (instancetype)initWithType:(SBHEntityType)type entityRange:(NSRange)entityRange keyRange:(NSRange)keyRange
{
    self = [super init];
    
    if (self) {
        self.type = type;
        self.entityRange = entityRange;
        self.keyRange = keyRange;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object
{
    if (object == self)
        return YES;
    if (!object || ![[object class] isEqual:[self class]])
        return NO;
    if (!NSEqualRanges([self entityRange], [object entityRange]))
        return NO;
    
    return YES;
}

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p; type = %@; range = %@; key = %@>",
            NSStringFromClass([self class]),
            self,
            NSStringFromEntityType(self.type),
            NSStringFromRange(self.entityRange),
            NSStringFromRange(self.keyRange)
            ];
}

@end
