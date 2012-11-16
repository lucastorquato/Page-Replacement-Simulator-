//
//  ResultTableViewController.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 15/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRFifo, PRSecondChance, PRMru, PRNur;

@interface ResultTableViewController : UITableViewController

@property (nonatomic, strong) PRFifo *fifo;
@property (nonatomic, strong) PRSecondChance *secondChance;
@property (nonatomic, strong) PRMru *mru;
@property (nonatomic, strong) PRNur *nur;

@property(nonatomic,strong) NSArray *intervalFrames;

@end
