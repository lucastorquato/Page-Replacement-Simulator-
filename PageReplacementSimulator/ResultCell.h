//
//  ResultCell.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 15/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *numberOfFramesLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitFifoLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitSecondChanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *hitMRULabel;
@property (strong, nonatomic) IBOutlet UILabel *hitNURLabel;

@end
