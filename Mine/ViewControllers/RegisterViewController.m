//
//  RegisterViewController.m
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *userRegistrationTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordRegistrationTextField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordRegistrationTextField;
@property (nonatomic) BOOL segue;

@end

@implementation RegisterViewController

- (IBAction)registerButton:(id)sender {
    
    if ([self.passwordRegistrationTextField.text isEqualToString:self.repeatPasswordRegistrationTextField.text]) {
    
            PFUser *user = [PFUser user];
            user.username = self.userRegistrationTextField.text;
            user.password = self.passwordRegistrationTextField.text;
            [user setObject:@[user.username] forKey:@"Contacts"];
        
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(!error){
                    [self performSegueWithIdentifier:@"SignUp OK" sender:self];
                }
                else{
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
