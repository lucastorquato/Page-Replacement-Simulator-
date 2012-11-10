//
//  PRMru.h
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 10/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PRMru : NSObject

@property(nonatomic,strong) NSArray *actionsMemoryReference;
@property(nonatomic,strong) NSArray *intervalFrames;

@property(nonatomic,strong) NSMutableArray *allHits;

- (void)run;

@end
