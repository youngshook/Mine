//
//  UserViewController.m
//  Mine
//
//  Created by Pol Quintana on 26/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "UserViewController.h"
#import <Parse/Parse.h>
#import <REFrostedViewController.h>

@interface UserViewController ()

@property (nonatomic) BOOL segue;

@end

@implementation UserViewController
#pragma mark - Buttons

- (IBAction)showMenu:(UIBarButtonItem *)sender {
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)logOutButton:(UIButton *)sender {
    UIAlertView *logOut = [[UIAlertView alloc]initWithTitle:@"Do you want to Log Out?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Log Out", nil];
    [logOut show];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"Log Out"])
    {
        return self.segue;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        [PFUser logOut];
        [self.navigationController popViewControllerAnimated:YES];
        self.segue = YES;
        [self performSegueWithIdentifier:@"Log Out" sender:self];
    }
}


#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segue = NO;
    // Do any additional setup after loading the view.
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
