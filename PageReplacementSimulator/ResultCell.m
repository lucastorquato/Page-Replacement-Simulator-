//
//  ResultCell.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 15/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "ResultCell.h"

@implementation ResultCell
@synthesize numberOfFramesLabel;
@synthesize hitFifoLabel;
@synthesize hitSecondChanceLabel;
@synthesize hitMRULabel;
@synthesize hitNURLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
