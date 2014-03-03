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

#import "IDEWorkspace+SBH.h"

#import "MethodSwizzle.h"
#import "StoryboardHelper.h"

@implementation IDEWorkspace (SBH)

+ (void)load
{
    MethodSwizzle(self, @selector(_updateIndexableFiles:), @selector(_jp_classmethod_sih_updateIndexableFiles:));
}

- (void)_jp_classmethod_sih_updateIndexableFiles:(id)arg1
{
    [self _jp_classmethod_sih_updateIndexableFiles:arg1];
    
    [[StoryboardHelper sharedPlugin] indexNeedsUpdate:self.index];
}

@end
