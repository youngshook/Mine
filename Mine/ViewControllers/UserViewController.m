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
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *entriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) UIImageView *imageViewBackup;

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
    // Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:@"user"];
    [self initialConfig];
    [self setUserImage:self.imageView];
    self.logOutButton.backgroundColor = [UIColor redColor];
    self.logOutButton.alpha = 0.5;
}

- (void)initialConfig{
    self.segue = NO;
    self.usernameLabel.text = [PFUser currentUser].username;
    self.contactsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[[PFUser currentUser] objectForKey:@"Contacts"] count]];
    PFQuery *query = [PFQuery queryWithClassName:@"Items"];
    [query whereKey:@"User" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.entriesLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[objects count]];
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void) setUserImage:(UIImageView *)imageView{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error) {
        if (!error) {
            // Found
            PFFile *file = [object objectForKey:@"Image"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    // image can now be set on a UIImageView
                    imageView.image = image;
                }
            }];
            
        } else {
            // Did not find for the current user
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error adding the item to the list. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
        }
    }];
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)viewDidAppear:(BOOL)animated{
    [self setUserImage:self.imageView];
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
