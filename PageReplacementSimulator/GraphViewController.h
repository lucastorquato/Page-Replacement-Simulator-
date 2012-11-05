//
//  GraphViewController.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRFifo;

@interface GraphViewController : UIViewController <CPTPlotDataSource>

@property(nonatomic,strong) IBOutlet CPTGraphHostingView *hostView;

@property(nonatomic,strong) NSArray *actionsMemoryReference;
@property(nonatomic,strong) NSArray *intervalFrames;

@property(nonatomic,strong) PRFifo *fifo;

- (IBAction)didTouchDoneButton:(id)sender;

@end
