//
//  AddViewController.h
//  Mine
//
//  Created by Pol Quintana on 23/09/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController

@property (strong, nonatomic) NSString *titleForLabel;
@property (strong, nonatomic) NSString *dateForLabel;
@property (strong, nonatomic) NSString *descriptionForLabel;
@property (strong, nonatomic) NSString *userForLabel;
@property (nonatomic) BOOL updatingObject;

@end
