//
//  GetNewViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 16/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "GetNewViewController.h"
#import "ListedViewController.h"
#import "ServerAppDelegate.h"
#import "Entity.h"


@interface GetNewViewController (){
    NSMutableData *responseData;
    NSMutableArray *array;
    NSArray *loadedArray;
    NSMutableString *queryString;
    Reachability *reach;
    bool isReachable;
}
@end


@implementation GetNewViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad{
    [super viewDidLoad];
    responseData = [NSMutableData data];
    NSLog(@"Get");
//    [self connectivityCheck];
}

//-(void) connectivityCheck{
//    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
//    __weak typeof(self)weakSelf = self;
//    reach.reachableBlock = ^(Reachability*reach)
//    {
//        __strong typeof (self)strongSelf=weakSelf;
//        strongSelf->isReachable=YES;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"REACHABLE!");
//        });
//    };
//    reach.unreachableBlock = ^(Reachability*reach)
//    {
//        __strong typeof (self)strongSelf=weakSelf;
//        strongSelf->isReachable=NO;
//        NSLog(@"UNREACHABLE!");
//    };
//    [reach startNotifier];
//}

-(void) viewWillAppear:(BOOL)animated{
    self.search.enabled=YES;
}


- (IBAction)search:(id)sender {
    
    if(isReachable){
        self.search.enabled=NO;
        array=[[NSMutableArray alloc]init];
        [self.view endEditing:YES];
        queryString=[[NSMutableString alloc] initWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"];
        [queryString appendString:[NSString stringWithFormat:@"?Item=%@&Code=%@&Colour=%@",self.item.text,self.code.text,self.colour.text]];
        NSLog(@"%@",queryString);
        [self sendRequest];
    }
    
    else{
        NSLog(@"Loading the cached Data from device... ");
        [self loadFromDevice];
        [self getValuesFromLoadedArray];
        [self performSegueWithIdentifier:@"showGet" sender:self];
    }
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSLog(@"%@",array);
    if([self.item.text isEqualToString:@""] && [self.code.text isEqualToString:@""] && [self.colour.text isEqualToString:@""]){
        [self loadFromDevice];
        [self saveToDevice];
    }
    [self performSegueWithIdentifier:@"showGet" sender:self];
}



#pragma mark - Core Data methods

-(void) saveToDevice{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSError *error;
    [self deleteAllData];
    for(int i=0;i<array.count;i++){
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                        inManagedObjectContext:context];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Item"] forKey:@"item"];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Code"] forKey:@"code"];
        [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Colour"] forKey:@"colour"];
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
        [array addObject:dict];
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




#pragma mark - Segue and Memory Management

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ListedViewController*list=[segue destinationViewController];
    list.array=array;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
