//
//  ServerDeleteAnItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerDeleteAnItemViewController.h"
#import "Entity.h"

@interface ServerDeleteAnItemViewController (){
    NSArray *loadedArray;
}

@end

@implementation ServerDeleteAnItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Delete");
    __weak typeof(self) weakSelf = self;
    [self.code.rac_textSignal subscribeNext:^(NSString *x) {
        typeof(self) strongSelf = weakSelf;
        NSString *codePattern =@"[0-9]$" ;
        self.deleteButton.enabled=[strongSelf validateString:x withPattern:codePattern];
    }];
}


-(void) viewWillAppear:(BOOL)animated{
    [self initializeViews];
}



- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}



-(void) initializeViews{
    self.code.text=@"";
}


- (IBAction)delete:(id)sender {
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    [self.view endEditing:YES];
    if([self.code.text  isEqualToString:@""]){
        [Utilities showAlert:@"Oops! I don't know what to Delete" withTitle:@"Error"];
        return;
    }
    if(appDelegate.isReachable){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
        [request setHTTPMethod:@"DELETE"];
        NSString *post = [NSString stringWithFormat:@"%@",self.code.text];
        NSData *requestBodyData = [post dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn){
            NSLog(@"No Connection");
        }
    }
    else{
        [self deleteOffline];
    }
        [self resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.deleteButton.enabled) {
        [self delete:self];
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


-(void) deleteOffline{
    [self loadFromDevice];
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription
//                  insertNewObjectForEntityForName:@"Entity"
//                  inManagedObjectContext:context];
//    [newContact setValue:self.item.text forKey:@"item"];
//    [newContact setValue:self.code.text forKey:@"code"];
//    [newContact setValue:self.colour.text forKey:@"colour"];
//    [newContact setValue:@1 forKey:@"flag"];
//    [context save:&error];
    for (Entity *entity in loadedArray) {
    if([entity.code isEqualToString:self.code.text])
        entity.flag=2;
        break;
    }
    [Utilities showAlert:@"Deleted offline" withTitle:@"Success!"];
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

#pragma mark - NSURL delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Resposnse Received");
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Data Received");
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError %@",error);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    [Utilities showAlert:@"Woohoo ! It's Gone " withTitle:@"Success!"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
