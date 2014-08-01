//
//  DataHandler.h
//  SampleServerDemo
//
//  Created by qbadmin on 31/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GetNewViewController.h>


@protocol DataHandlerDelegate<NSObject>

    - (void)refreshPage:(NSMutableArray*)arrayOfObjects;

@end



@interface DataHandler : NSObject

    @property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

    - (void)getRequest:(NSString *)queryString;
    - (void )postRequest:(NSString *)queryString;
    - (void )putRequest:(NSString *)queryString;
    - (void )deleteRequest:(NSString *)queryString;
    - (void ) reachabilityCheck;

    - (NSURL *)applicationDocumentsDirectory;

    @property (nonatomic, weak) id <DataHandlerDelegate> delegate;

@end
