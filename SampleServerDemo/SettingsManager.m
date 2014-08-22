//
//  SettingsManager.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.


#import "SettingsManager.h"

@implementation SettingsManager

static SettingsManager *settings = nil;


+ (SettingsManager *) instance{
    static SettingsManager *_default = nil;
    if (_default == nil)
    {
        _default = [[SettingsManager alloc] init];
    }
    
    return _default;
}


+ (id) SettingsManagerClass
{
    if (! settings) {
        
    }
    return settings;
}

- (id)init
{
    if (! settings) {
    }
    return settings;
}
@end
