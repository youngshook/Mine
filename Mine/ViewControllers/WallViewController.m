//
//  WallViewController.m
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "WallViewController.h"
#import <Parse/Parse.h>

@interface WallViewController () 

@end

@implementation WallViewController

- (IBAction)logOutButton:(UIBarButtonItem *)sender {
    
    UIAlertView *logOut = [[UIAlertView alloc]initWithTitle:@"Log Out" message:@"Do you want to Log Out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log Out", nil];
    [logOut show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [PFUser logOut];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
