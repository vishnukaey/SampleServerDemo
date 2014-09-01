//
//  ListedViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 18/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ListedViewController.h"
#import "ItemCell.h"
#import "Entity.h"
#import "CloudStorage.h"

@interface ListedViewController  () {
    NSMutableArray *arrayOfContents;
    NSArray *loadedArray;
    NSMutableData *responseData;
    NSMutableString *queryString;
    Reachability *reach;
}

@end

@implementation ListedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    responseData = [NSMutableData data];
    arrayOfContents=[NSMutableArray arrayWithArray:_array];
        [self.tableView addPullToRefreshWithActionHandler:^{
        [self makeARequestCall];
        [self.tableView.pullToRefreshView stopAnimating];
    } withBackgroundColor:[UIColor lightGrayColor]];
    
    [RACObserve(self.searchBar, text)
     subscribeNext:^(NSString *newName) {
         [self makeARequestCall];
     }];
    
    RACSignal *signal = [self rac_signalForSelector:
                         @selector(searchBar:textDidChange:) fromProtocol:
                         @protocol(UISearchBarDelegate)];
    __weak typeof(self)weakSelf = self;
    [signal subscribeNext:^(RACTuple *arguments) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.searchBar == arguments.first) {
            [self makeARequestCall];
        }
    }];
    
    
}


#pragma mark - Methods to handle request
-(void) makeARequestCall{
    queryString=[[NSMutableString alloc ]initWithString:self.searchBar.text];
    StoreManager *manager= [[StoreManager alloc] init];
    DataHandler *object = [manager getStore];
    [object getRequest:queryString requestSucceeded:^(NSArray *array) {
        arrayOfContents = [array mutableCopy];
        [self.tableView reloadData];
    } requestFailed:^(NSError *error) {
        NSLog(@"Error Recieving data");
    }];
}


#pragma mark - SearchBar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar {
    [self.view endEditing:YES];
}


#pragma mark - DataHandler delegate
- (void)refreshTableView:(NSArray*)arrayOfObjects{
    arrayOfContents=[arrayOfObjects mutableCopy];
    [self.tableView reloadData];
}


#pragma mark - Table View delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfContents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.item.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Item"];
    cell.code.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Code"];
    cell.colour.text=[[arrayOfContents objectAtIndex:indexPath.row] valueForKey:@"Colour"];
    return cell;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
