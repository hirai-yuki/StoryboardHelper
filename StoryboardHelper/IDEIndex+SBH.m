//
//  IDEIndex+SBH.h
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

#import "IDEIndex+SBH.h"

#import "MethodSwizzle.h"
#import "StoryboardHelper.h"

@implementation IDEIndex (SBH)

+ (void)load
{
    MethodSwizzle(self, @selector(close), @selector(_jp_classmethod_sih_close));
}

- (void)_jp_classmethod_sih_close
{
    [[StoryboardHelper sharedPlugin] removeStoryboardIdentifiersForIndex:self];
    
    [self _jp_classmethod_sih_close];
}

@end
