//
//  ServerListAllItemsViewController.h
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KoaPullToRefresh.h>
//@protocol refreshTableDelegate <NSObject>
//- (void) sendRequest;
//@end
@interface ServerListAllItemsViewController : UITableViewController
@property (nonatomic, strong) NSArray *array;
//@property (nonatomic, weak) id <refreshTableDelegate> delegate;
@end
