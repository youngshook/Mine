//
//  AddViewController.m
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "AddViewController.h"
#import <Parse/Parse.h>

@interface AddViewController ()
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation AddViewController

#pragma mark - button

- (IBAction)saveItemOnParse:(UIBarButtonItem *)sender {
    
    PFObject *itemToAdd = [PFObject objectWithClassName:@"Items"];
    [itemToAdd setObject:self.titleTextField.text forKey:@"Title"];
    [itemToAdd setObject:self.dateTextField.text forKey:@"Date"];
    [itemToAdd setObject:self.descriptionTextView.text forKey:@"Description"];
    [itemToAdd setObject:[PFUser currentUser].username forKey:@"User"];
    
    [itemToAdd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Item added");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error adding the item to the list. Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [error show];
        }
    }];
}


#pragma mark - implementation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.descriptionTextView.layer.borderWidth = 0.2f;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor]CGColor];
    self.descriptionTextView.layer.cornerRadius = 8;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
    
}

-(void)updateDateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm - dd/MM/yyyy"];
    self.dateTextField.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:picker.date]];
}


-(void) dismissKeyboard{
    [self.descriptionTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.dateTextField resignFirstResponder];

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
