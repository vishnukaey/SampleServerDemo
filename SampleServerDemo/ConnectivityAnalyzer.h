//
//  ConnectivityAnalyzer.h
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectivityAnalyzer : NSObject
    +(ConnectivityAnalyzer *) instance;
    @property (nonatomic, assign) BOOL canConnectToInternet;
@end
