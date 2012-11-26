//
//  MainViewController.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewDelegate <NSObject>

- (void)inputProblemWithActions:(NSArray*)actionsMemory intervalFrames:(NSArray*)intervalFrames andIntervalTimeBitR:(NSInteger)intervalTimeR;

@end


@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextView *paginationReferencesTextField;

@property (strong, nonatomic) IBOutlet UITextField *firstIntervalFramesTextField;
@property (strong, nonatomic) IBOutlet UITextField *secondIntervalFramesTextField;
@property (strong, nonatomic) IBOutlet UITextField *intervalTimeBitRTextField;

@property (strong, nonatomic) id<MainViewDelegate> delegate;

- (IBAction)didTouchRunButton:(id)sender;
//- (void)inputProblemWithActions:(NSArray*)actionsMemory intervalFrames:(NSArray*)intervalFrames andIntervalTimeBitR:(NSInteger)intervalTimeR;
- (IBAction)deleteAllReferencesText:(id)sender;

@end
