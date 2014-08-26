//
//  OfflineStorage.h
//  SampleServerDemo
//
//  Created by Vishnu on 21/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "DataHandler.h"

@interface OfflineStorage : DataHandler


#pragma mark - CoreData
    @property ( strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property ( strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property ( strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    - (NSURL *)applicationDocumentsDirectory;


#pragma mark - Overridden methods

    - (NSArray*)getRequest:(NSString *)queryString;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;
    - (NSArray*)getRequest;
    -(void) deleteAllData;
@end
