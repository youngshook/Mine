//
//  DetailViewController.m
//  Mine
//
//  Created by Pol Quintana on 25/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "DetailViewController.h"
#import "AddViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DetailViewController

#pragma mark  - Lazy initilization

-(void)updateUI{
    self.descriptionTextView.text = self.descriptionForLabel;
    self.descriptionForLabel = nil;
    self.titleLabel.text = self.titleForLabel;
    self.titleForLabel = nil;
    self.dateLabel.text = self.dateForLabel;
    self.dateForLabel = nil;
}

#pragma mark - Prepare for Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"Edit Item"]) {
        if ([segue.destinationViewController isKindOfClass:[AddViewController class]]) {
            AddViewController *avc = (AddViewController *)segue.destinationViewController;
            
            avc.titleForLabel = self.titleLabel.text;
            avc.dateForLabel = self.dateLabel.text;
            avc.descriptionForLabel = self.descriptionTextView.text;
            avc.userForLabel = self.userForLabel;
            avc.updatingObject = YES;
        }
    }
}

#pragma mark - System

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionTextView.layer.borderWidth = 0.2f;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor]CGColor];
    self.descriptionTextView.layer.cornerRadius = 8;
    [self updateUI];
    
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
