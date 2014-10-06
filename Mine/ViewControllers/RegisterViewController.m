//
//  RegisterViewController.m
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD.h>

@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userRegistrationTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordRegistrationTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordRegistrationTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailRegistrationField;
@property (nonatomic) BOOL segue;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation RegisterViewController

- (IBAction)registerButton:(id)sender {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Signing Up...";
    
    if ([self.passwordRegistrationTextField.text isEqualToString:self.repeatPasswordRegistrationTextField.text]) {
            [self.hud show:YES];
            PFUser *user = [PFUser user];
            user.username = self.userRegistrationTextField.text;
            user.password = self.passwordRegistrationTextField.text;
            user.email = self.emailRegistrationField.text;
        
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(!error){
                    PFObject *userRelation = [PFObject objectWithClassName:@"Relations"];
                    [userRelation setObject:self.userRegistrationTextField.text forKey:@"username"];
                    [userRelation setObject:@[self.userRegistrationTextField.text] forKey:@"Contacts"];
                    [userRelation saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                        [self.hud show:NO];
                        if(!error){
                            [self performSegueWithIdentifier:@"SignUp OK" sender:self];
                        }
                    }];
                }
                else{
                    [self.hud show:NO];
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    self.segue = NO;
                }
            }];
    }
    else{
        UIAlertView *noMatchAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The passwords do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noMatchAlert show];
        self.segue = NO;

        
    }
    
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"SignUp OK"])
    {
        return self.segue;
    }
    return YES;
}


#pragma mark - Initialization


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void) dismissKeyboard{
    [self.userRegistrationTextField resignFirstResponder];
    [self.passwordRegistrationTextField resignFirstResponder];
    [self.repeatPasswordRegistrationTextField resignFirstResponder];
    [self.emailRegistrationField resignFirstResponder];
    
}

/*

- (void)didReceiveMemoryWarning {
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
