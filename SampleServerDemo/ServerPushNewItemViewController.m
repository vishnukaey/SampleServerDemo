//
//  ServerPushNewItemViewController.m
//  SampleServerDemo
//
//  Created by qbadmin on 09/07/14.
//  Copyright (c) 2014 Vishnu. All rights reserved.
//

#import "ServerPushNewItemViewController.h"

@interface ServerPushNewItemViewController ()

@end

@implementation ServerPushNewItemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)submitAnItem:(id)sender {
    PFObject *items=[PFObject objectWithClassName:@"WebService"];
    items[@"Item"]=self.item.text;
    items[@"Code"]=self.code.text;
    items[@"Colour"]=self.colour.text;
    [items saveInBackground];
    [self resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
