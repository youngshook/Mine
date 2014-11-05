//
//  WelcomeViewController.m
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "WelcomeViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD.h>

@interface WelcomeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic) BOOL segue;
@property (strong, nonatomic) IBOutlet UISwitch *rememberMeSwitch;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation WelcomeViewController

- (IBAction)signInButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Signing In...";
    [self.hud show:YES];
    
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error){
        if (!error) {
            if (self.rememberMeSwitch.on == YES) {
                [defaults setObject:self.userTextField.text forKey:@"username"];
                [defaults setObject:self.passwordTextField.text forKey:@"password"];
            }
            [self.hud show:NO];
            [self performSegueWithIdentifier:@"SignIn OK" sender:self];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            self.segue = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
    }];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"SignIn OK"])
    {
        return self.segue;
    }
    return YES;
}

#pragma mark - Initialization


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userTextField.text = [fetchDefaults objectForKey:@"username"];
    self.passwordTextField.text = [fetchDefaults objectForKey:@"password"];
    if([self.userTextField.text length]>0){
        self.rememberMeSwitch.on = YES;
        [self signInButton:self];
        
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void) dismissKeyboard{
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

/*- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
