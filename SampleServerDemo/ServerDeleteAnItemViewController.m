//
//  ServerDeleteAnItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerDeleteAnItemViewController.h"

@interface ServerDeleteAnItemViewController ()

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
- (IBAction)delete:(id)sender {
    PFQuery *query=[PFQuery queryWithClassName:@"WebService"];
    [query whereKey:@"Code" equalTo:self.code.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(int i=0; i<array.count;i++)
            {
                [[array objectAtIndex:i] deleteInBackground];
        }}];
    [self resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
