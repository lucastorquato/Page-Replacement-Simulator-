//
//  MainViewController.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *paginationReferencesTextField;

@property (strong, nonatomic) IBOutlet UITextField *firstIntervalFramesTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondIntervalFramesTextField;

- (IBAction)didTouchRunButton:(id)sender;

@end
