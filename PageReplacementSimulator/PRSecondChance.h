//
//  PRSecondChance.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 05/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRSecondChance : NSObject

@property(nonatomic,strong) NSArray *actionsMemoryReference;
@property(nonatomic,strong) NSArray *intervalFrames;

@property(nonatomic,strong) NSMutableArray *allHits;

@property(nonatomic,assign) NSInteger intervalTimeBitR;

- (void)run;

@end
