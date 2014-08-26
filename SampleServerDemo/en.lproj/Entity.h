//
//  Entity.h
//  SampleServerDemo
//
//  Created by Vishnu on 26/08/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * colour;
@property (nonatomic, retain) NSString * flag;
@property (nonatomic, retain) NSString * item;

@end
