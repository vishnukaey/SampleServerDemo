//
//  CloudStorage.h
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "DataHandler.h"

//@protocol CloudStorageDelegate <NSObject>
//    -(void) refreshTableView :(NSArray *) array;
//@end
//

@interface CloudStorage : DataHandler
//    @property (nonatomic, weak) id <CloudStorageDelegate> delegate;
    - (NSArray*)getRequest:(NSString *)queryString;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;
@end
