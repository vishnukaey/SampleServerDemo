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

@interface ListedViewController (){
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
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad{
    ServerAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [super viewDidLoad];
    responseData = [NSMutableData data];
    arrayOfContents=[NSMutableArray arrayWithArray:_array];
    
    
    [self.tableView addPullToRefreshWithActionHandler:^{
//        if(appDelegate.isReachable)
//            [self makeARequestCall];
//        else{
//            [self loadFromDevice];
//            [self getValuesFromLoadedArray];
//        }
        [self.tableView.pullToRefreshView stopAnimating];
    } withBackgroundColor:[UIColor lightGrayColor]];
    
    
    [RACObserve(self.searchBar, text)
     subscribeNext:^(NSString *newName) {
//         if(appDelegate.isReachable)
//             [self makeARequestCall];
//         else{
//             [self loadFromDevice];
//             [self getValuesFromLoadedArray];
//         }
     }];
    
    
    RACSignal *signal = [self rac_signalForSelector:@selector(searchBar:textDidChange:) fromProtocol:@protocol(UISearchBarDelegate)];
    
    __weak typeof(self)weakSelf = self;
    
    [signal subscribeNext:^(RACTuple *arguments) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.searchBar == arguments.first) {
            if(appDelegate.isReachable){
                [self makeARequestCall];
            }
            else{
                [self loadFromDevice];
                [self getValuesFromLoadedArray];
            }
        }
    }];
}


#pragma mark - Methods to handle request
-(void) makeARequestCall{
    queryString=[[NSMutableString alloc ]initWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"];
    [queryString appendString:[NSString stringWithFormat:@"?Item=%@&Code=%@&Colour=%@",self.searchBar.text,self.searchBar.text,self.searchBar.text]];
    [self sendRequest];
}



-(void) sendRequest{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:queryString]];
    [request setHTTPMethod:@"GET"];
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}



#pragma mark - SearchBar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];
}




- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar {
    [self.view endEditing:YES];
}



#pragma mark - NSURL delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
    NSLog(@"Resposnse Received");
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    NSLog(@"Data Received");
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@",error);
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    
    if(responseData){
    arrayOfContents = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
        if([self.searchBar.text isEqualToString:@""])
        {
            [self deleteAllData];
            [self saveToDevice];
        }
    }
    NSLog(@"%@",arrayOfContents);
    [self.tableView reloadData];
}


#pragma mark - Core Data methods

-(void) saveToDevice{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSError *error;
    [self deleteAllData];
    for(int i=0;i<arrayOfContents.count;i++){
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                   inManagedObjectContext:context];
        [newContact setValue:[[arrayOfContents objectAtIndex:i] valueForKey:@"Item"] forKey:@"item"];
        [newContact setValue:[[arrayOfContents objectAtIndex:i] valueForKey:@"Code"] forKey:@"code"];
        [newContact setValue:[[arrayOfContents objectAtIndex:i] valueForKey:@"Colour"] forKey:@"colour"];
    }
    [context save:&error];
}



-(void)deleteAllData{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    for(NSManagedObject *object in loadedArray){
        [context deleteObject:object];
    }
}



-(void) getValuesFromLoadedArray{
    for (Entity *entity in loadedArray) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:entity.item forKey:@"Item"];
        [dict setObject:entity.code forKey:@"Code"];
        [dict setObject:entity.colour forKey:@"Colour"];
        [arrayOfContents addObject:dict];
    }
}




-(void) loadFromDevice{
    ServerAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *moc = [appDelegate managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Entity" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    loadedArray=[moc executeFetchRequest:request error:&error];
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
