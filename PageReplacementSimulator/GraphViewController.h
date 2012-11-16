//
//  GraphViewController.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class PRFifo, PRSecondChance, PRMru, PRNur;

@interface GraphViewController : UIViewController <CPTPlotDataSource, MainViewDelegate>

@property(nonatomic,strong) IBOutlet CPTGraphHostingView *hostView;

@property(nonatomic,strong) NSArray *actionsMemoryReference;
@property(nonatomic,strong) NSArray *intervalFrames;
@property(assign, nonatomic) NSInteger intervalTimeBitR;

@property(nonatomic,strong) PRFifo *fifo;
@property(nonatomic,strong) PRSecondChance *secondChance;
@property(nonatomic,strong) PRMru *mru;
@property(nonatomic,strong) PRNur *nur;

@property(nonatomic,strong) id<MainViewDelegate> delegate;

- (IBAction)didTouchDoneButton:(id)sender;
- (IBAction)didTouchTableButton:(id)sender;
- (IBAction)didTouchNewButton:(id)sender;


@end
