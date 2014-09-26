//
//  ImagePickerViewController.m
//  Mine
//
//  Created by Pol Quintana on 26/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ImagePickerViewController.h"
#import <Parse/Parse.h>
#import <MBProgressHUD.h>

@interface ImagePickerViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadButton;

@end

@implementation ImagePickerViewController

- (IBAction)uploadButton:(UIBarButtonItem *)sender {
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
            
            // Show progress
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Uploading";
            [hud show:YES];
            
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [hud show:NO];
                    // The image has now been uploaded to Parse. Associate it with a new object
                    NSLog(@"Item uploaded");
                    [self.navigationController popViewControllerAnimated:YES];
                    UIAlertView *added = [[UIAlertView alloc]initWithTitle:@"The item was added" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [added show];
                    [self performSelector:@selector(dismiss:) withObject:added afterDelay:2];
                }
                else{
                    // Error
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                }];
            }
    }];


}

-(void) dismiss:(UIAlertView *)alert{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}


- (IBAction)chooseFromLibrary:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    self.uploadButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)takeAPhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [UIImage imageNamed:@"user"];
    self.uploadButton.enabled = NO;
    // Do any additional setup after loading the view.
    [self setUserImage];
}

- (void) setUserImage{
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
                    self.imageView.image = image;
                }
            }];
            
        } else {
            // Did not find for the current user
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error adding the item to the list. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
        }
    }];
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
