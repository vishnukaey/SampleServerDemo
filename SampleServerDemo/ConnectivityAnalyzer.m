//
//  ConnectivityAnalyzer.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ConnectivityAnalyzer.h"

@implementation ConnectivityAnalyzer
+ (ConnectivityAnalyzer *) instance{
    static ConnectivityAnalyzer *_default = nil;
    if (_default == nil)
    {
        _default = [[ConnectivityAnalyzer alloc] init];
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        reach.reachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"REACHABLE!");
                _default.canConnectToInternet = YES;
            });
        };
        
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            _default.canConnectToInternet = NO;
        };
        [reach startNotifier];
    }
    
    return _default;
}
@end
