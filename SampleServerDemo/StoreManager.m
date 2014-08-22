//
//  StoreManager.m
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "StoreManager.h"
#import "ConnectivityAnalyzer.h"
#import "SettingsManager.h"
#import "OfflineStorage.h"
#import "CloudStorage.h"


@implementation StoreManager

-( DataHandler *) getStore{
    ConnectivityAnalyzer *con =[ConnectivityAnalyzer instance];
    
    if([con canConnectToInternet])
   {
       return [[CloudStorage alloc] init];
   }
    else
        return [[OfflineStorage alloc] init];
}
@end
