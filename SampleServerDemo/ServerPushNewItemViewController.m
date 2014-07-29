//
//  ServerPushNewItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerPushNewItemViewController.h"
#import "Entity.h"


@interface ServerPushNewItemViewController (){
    NSArray *loadedArray;
}
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation ServerPushNewItemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    RAC(self.submitButton, enabled) = [RACSignal
                                combineLatest:@[ self.item.rac_textSignal, self.code.rac_textSignal, self.colour.rac_textSignal]
                                reduce:^(NSString *itemText, NSString *codeText, NSString *colorText) {
                                    
                                    NSString *itemPattern = @"[A-Z0-9a-z@!&]";
                                    NSString *codePattern = @"[0-9]$";
                                    NSString *colourPattern = @"[A-Za-z@!&]";
                                    
                                    return @([self validateString:itemText withPattern:itemPattern] && [self validateString:codeText withPattern:codePattern] && [self validateString:colorText withPattern:colourPattern]);
                                }];
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        [self loadFromDevice];
        for (Entity *entity in loadedArray) {
            if(entity.flag==1){
                entity.flag=0;
                [self saveEntityInBackground:entity];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            NSLog(@"Saved to MySQL");
        });
    };
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
    };
    [reach startNotifier];
}



-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self initializeViews];
}




-(void) initializeViews{
    self.item.text=@"";
    self.code.text=@"";
    self.colour.text=@"";
    self.emailStatus.image=[UIImage imageNamed:@""];
    self.codeStatus.image=[UIImage imageNamed:@""];
    self.colourStatus.image=[UIImage imageNamed:@""];
}


#pragma mark - Methods to Post

- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern
{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}


-(void) saveEntityInBackground:(Entity *) entity{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
    [request setHTTPMethod:@"POST"];
    NSString *post = [NSString stringWithFormat:@"%@/%@/%@/",entity.item,entity.code,entity.colour];
    NSData *requestBodyData = [post dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(!conn){
        NSLog(@"No Connection");
    }
}

- (IBAction)submitAnItem:(id)sender {
    
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"http://10.3.0.145:9000/Sample3/DBConnector"]];
  [request setHTTPMethod:@"POST"];
  NSString *post = [NSString stringWithFormat:@"%@/%@/%@/",self.item.text,self.code.text,self.colour.text];
  NSData *requestBodyData = [post dataUsingEncoding:NSUTF8StringEncoding];
  request.HTTPBody = requestBodyData;
  NSURLConnection*conn=[[NSURLConnection alloc] initWithRequest:request delegate:self];
  if(!conn){
      NSLog(@"No Connection");
  }
  [self resignFirstResponder];
}

-(void) postToPhone{
    ServerAppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSError *error;
    NSManagedObject *newContact;
    newContact = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Entity"
                      inManagedObjectContext:context];
    [newContact setValue:self.item.text forKey:@"item"];
    [newContact setValue:self.code.text forKey:@"code"];
    [newContact setValue:self.colour.text forKey:@"colour"];
    [newContact setValue:@1 forKey:@"flag"];
    [context save:&error];
    [Utilities showAlert:@"Added offline" withTitle:@"Success!"];
}




#pragma mark - TextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([self.submitButton isEnabled]) {
        [self submitAnItem:self.submitButton];
    }
    return YES;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
    [self postToPhone];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    [Utilities showAlert:@"Woohoo ! It's added " withTitle:@"Success!"];
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


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
