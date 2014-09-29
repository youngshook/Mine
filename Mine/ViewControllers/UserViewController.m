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
#import <MBProgressHUD.h>

@interface UserViewController ()

@property (nonatomic) BOOL segue;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *entriesLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *logOutButton;
@property (strong, nonatomic) UIImageView *imageViewBackup;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation UserViewController

#pragma mark - Image Preparation

- (IBAction)imageButtonToActionSheet:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Photo" otherButtonTitles:@"Choose from Library", @"Take a Photo", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self removeImage];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Removing";
        [self.hud show:YES];
    }
    else if (buttonIndex == 1) {
        [self chooseImageFromLibrary];
    }
    if (buttonIndex == 2) {
        [self takeAPhoto];
    }
}


-(void)chooseImageFromLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)takeAPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Uploading";
    [self.hud show:YES];
    [self uploadImageToParse];
}

#pragma mark - Upload Image to Parse code

-(void)uploadImageToParse{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error) {
        if (!error) {
            // Save
            
            // Convert to JPEG with 50% quality
            NSData* data = UIImageJPEGRepresentation(self.imageView.image, 0.5f);
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
            
            // Save the image to Parse
            [object setObject:imageFile forKey:@"Image"];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    // The image has now been uploaded to Parse. Associate it with a new object
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"Item uploaded");
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
    
    
}

- (void)removeImage{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error) {
        if (!error) {
            [object removeObjectForKey:@"Image"];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    // The image has now been uploaded to Parse. Associate it with a new object
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSLog(@"Item deleted");
                    self.imageView.image = [UIImage imageNamed:@"user"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    UIAlertView *added = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not remove the image. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [added show];
                }
            }];
        }
    }];

}


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
    //[self setUserImage:self.imageView];
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
