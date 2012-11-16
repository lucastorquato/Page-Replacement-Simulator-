//
//  PRNru.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 10/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRNur : NSObject

@property(nonatomic,strong) NSArray *actionsMemoryReference;
@property(nonatomic,strong) NSArray *intervalFrames;

@property(nonatomic,strong) NSMutableArray *allHits;

@property(nonatomic,assign) NSInteger intervalTimeBitR;

- (void)run;

@end
