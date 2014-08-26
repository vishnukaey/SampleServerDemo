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
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Delete");
    
    __weak typeof(self) weakSelf = self;
    [self.code.rac_textSignal subscribeNext:^(NSString *character) {
        typeof(self) strongSelf = weakSelf;
        NSString *codePattern =@"[0-9]$" ;
        self.deleteButton.enabled=[strongSelf validateString:character withPattern:codePattern];
    }];
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.code.text=@"";
}


- (IBAction)delete:(id)sender {
    [self.view endEditing:YES];
    NSString *deleteString = [NSString stringWithFormat:@"%@",self.code.text];
    [self resignFirstResponder];
    StoreManager *manager= [[StoreManager alloc] init];
    DataHandler *object = [manager getStore];
    [object deleteRequest:deleteString];
    [Utilities showAlert:@"Deleted !" withTitle:@"Success"];
}


- (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern{
    return ([string rangeOfString:pattern options:NSRegularExpressionSearch].location != NSNotFound );
}


#pragma mark- TextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.deleteButton.enabled) {
        [self delete:self];
    }
    return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
