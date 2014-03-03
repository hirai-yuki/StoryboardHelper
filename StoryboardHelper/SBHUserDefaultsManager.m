//
//  SBHUserDefaultsManager.m
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

#import "SBHUserDefaultsManager.h"

static NSString * const SBHUserDefaultManagerEnabledKey = @"jp.classmethod.SBH.enabled";

@implementation SBHUserDefaultsManager

+ (instancetype)sharedManager
{
    static id _sharedManager;
	static dispatch_once_t _onceToken;
    
	dispatch_once(&_onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
    
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // Register defaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults registerDefaults:@{SBHUserDefaultManagerEnabledKey: @(YES)}];
        [userDefaults synchronize];
    }
    
    return self;
}


#pragma mark - Accessors

- (void)setEnabled:(BOOL)enabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:enabled forKey:SBHUserDefaultManagerEnabledKey];
    [userDefaults synchronize];
}

- (BOOL)isEnabled
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:SBHUserDefaultManagerEnabledKey];
}

@end
