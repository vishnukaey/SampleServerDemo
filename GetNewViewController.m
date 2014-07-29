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
}



- (IBAction)search:(id)sender {
    array=[[NSMutableArray alloc]init];
    [self.view endEditing:YES];
    queryString=[[NSMutableString alloc ]initWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"];
    [queryString appendString:[NSString stringWithFormat:@"?Item=%@&Code=%@&Colour=%@",self.item.text,self.code.text,self.colour.text]];
    NSLog(@"%@",queryString);
    [self sendRequest];
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
    NSLog(@"Loading the cached Data from device... ");
    [self loadFromDevice];
    [self getValuesFromLoadedArray];
    [self performSegueWithIdentifier:@"showGet" sender:self];
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    array = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:Nil];
    NSLog(@"%@",array);
    [self loadFromDevice];
    [self saveToDevice];
    [self performSegueWithIdentifier:@"showGet" sender:self];
}




#pragma mark - Core Data methods

-(void) saveToDevice{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSError *error;
    for(int i=0;i<array.count;i++){
        if([self isANewData:[array objectAtIndex:i]])
        {
            NSManagedObject *newContact;
            newContact = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Entity"
                          inManagedObjectContext:context];
            [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Item"] forKey:@"item"];
            [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Code"] forKey:@"code"];
            [newContact setValue:[[array objectAtIndex:i] valueForKey:@"Colour"] forKey:@"colour"];
    }
    else
        continue;
    }[context save:&error];
}




-(bool) isANewData:(NSDictionary*)item{
    bool flag=YES;
    for (Entity *entity in loadedArray) {
        if([[item valueForKey:@"Item"] isEqualToString:entity.item] && [[item valueForKey:@"Code"] isEqualToString:entity.code] && [[item valueForKey:@"Colour"] isEqualToString:entity.colour] )
        {
            flag=NO;
            break;
        }
    }
    return flag;
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
