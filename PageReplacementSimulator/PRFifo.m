//
//  PRFifo.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "PRFifo.h"

@implementation PRFifo

- (void)initialConfig
{
    self.actionsMemoryReference = [self removeWriteOrReadActionsOnActionsMemory:self.actionsMemoryReference];
}

- (void)run
{
    [self initialConfig];
    
    if (!self.allHits) {
        self.allHits = [[NSMutableArray alloc] init];
    }
    
    for (NSString *frame in self.intervalFrames) {
        //int frame = 4;
        int hit = 0;
        int fault = 0;
        
        NSMutableArray *framePage =[[NSMutableArray alloc] initWithCapacity:frame.integerValue];  // FRAME SNAPSHOT
        
        NSMutableArray *loadPages = [[NSMutableArray alloc] initWithCapacity:frame.integerValue]; // LISTA DUPLAMENTE ENCADEADA
        
        for (int i = 0 ; i < self.actionsMemoryReference.count ; i++) {
            NSString *actionMemory = [self.actionsMemoryReference objectAtIndex:i];
            
            // *** MAIN BLOCK ***
            if ([loadPages containsObject:actionMemory]) {  // SE NO FRAME EXISTE A PAGINA, INCREMENTE HIT.
                hit++;
            }else{                                          // CASO CONTRÁRIO, ADICIONE A PAGINA NO FRAME.
                fault++;
                if (loadPages.count == frame.integerValue) {             // SE O FRAME ESTIVER CHEIO, REMOVA O PRIMEIRO OBJETO.e
                    /**FRAME SNAPSHOT**/ [framePage replaceObjectAtIndex:[framePage indexOfObject:[loadPages objectAtIndex:0]] withObject:actionMemory];
                    [loadPages removeObjectAtIndex:0];
                }else{
                    /**FRAME SNAPSHOT**/ [framePage addObject:actionMemory];
                }
                [loadPages addObject:actionMemory];
            }
            //
            
            for (int i = 0 ; i < loadPages.count ; i++) {
                NSLog(@">>>LISTA ENCADEADA (%d) %@ ",i, [loadPages objectAtIndex:i]);
            }
            NSLog(@"Number of hits: %d",hit);
        }
        
        // Final Result
        NSLog(@"Number of hits %d and fault %d",hit,fault);
        for (int i = 0 ; i < loadPages.count ; i++) {
            NSLog(@">>> (%d) %@ ",i, [loadPages objectAtIndex:i]);
        }
        
        for (int i = 0 ; i < framePage.count ; i++) {
            NSLog(@">>>FRAME SNAPSHOW (%d) %@ ",i, [framePage objectAtIndex:i]);
        }
        
        [self.allHits addObject:[NSString stringWithFormat:@"%d",hit]];
    }
}

/*
- (void)runExample
{
    [self initialConfig];
    
    int frame = 4;
    int hit = 0;
    int fault = 0;
    NSMutableArray *framePage =[[NSMutableArray alloc] initWithCapacity:frame];  // FRAME SNAPSHOT
    
    NSMutableArray *loadPages = [[NSMutableArray alloc] initWithCapacity:frame]; // LISTA DUPLAMENTE ENCADEADA
    
    for (int i = 0 ; i < self.actionsMemoryReference.count ; i++) {
        NSString *actionMemory = [self.actionsMemoryReference objectAtIndex:i];
        
        // *** MAIN BLOCK ***
        if ([loadPages containsObject:actionMemory]) {  // SE NO FRAME EXISTE A PAGINA, INCREMENTE HIT.
            hit++;
        }else{                                          // CASO CONTRÁRIO, ADICIONE A PAGINA NO FRAME.
            fault++;
            if (loadPages.count == frame) {             // SE O FRAME ESTIVER CHEIO, REMOVA O PRIMEIRO OBJETO.e
                [framePage replaceObjectAtIndex:[framePage indexOfObject:[loadPages objectAtIndex:0]] withObject:actionMemory]; //FRAME SNAPSHOT
                [loadPages removeObjectAtIndex:0];
            }else{
                [framePage addObject:actionMemory]; //FRAME SNAPSHOT
            }
            [loadPages addObject:actionMemory];
        }
        //
        
        for (int i = 0 ; i < loadPages.count ; i++) {
            NSLog(@">>>LISTA ENCADEADA (%d) %@ ",i, [loadPages objectAtIndex:i]);
        }
        NSLog(@"Number of hits: %d",hit);
    }
    
    // Final Result
    NSLog(@"Number of hits %d and fault %d",hit,fault);
    for (int i = 0 ; i < loadPages.count ; i++) {
        NSLog(@">>> (%d) %@ ",i, [loadPages objectAtIndex:i]);
    }
    
    for (int i = 0 ; i < framePage.count ; i++) {
        NSLog(@">>>FRAME SNAPSHOW (%d) %@ ",i, [framePage objectAtIndex:i]);
    }
}
*/

#pragma mark - Utils

- (NSArray*)removeWriteOrReadActionsOnActionsMemory:(NSArray*)actionsMemory
{
    NSMutableArray *newActionsMemory = [[NSMutableArray alloc] init];
    for (NSString *action in actionsMemory) {
         [newActionsMemory addObject:[action substringToIndex:1]];
    }
    
    for (NSString *action in newActionsMemory) {
        NSLog(@"%@",action);
    }
    
    return [NSArray arrayWithArray:newActionsMemory];
}


@end
