//
//  SBHRegularExpressionPattern+type.h
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

// Models
#import "SBHEntity.h"

@interface SBHRegularExpressionPattern (type)

@property (nonatomic, assign, readonly) SBHEntityType type;

+ (instancetype)patternWithType:(SBHEntityType)type;

@end
