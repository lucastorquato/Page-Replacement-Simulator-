//
//  PRSecondChance.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 05/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "PRSecondChance.h"

@implementation PRSecondChance


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
        
        NSMutableArray *bitRList = [[NSMutableArray alloc] initWithCapacity:frame.integerValue];
        
        for (int i = 0 ; i < self.actionsMemoryReference.count ; i++) {
            
            // COLOCAR TODOS OS BIT R EM ZERO QUANDO O NUMERO DE ACOES CHEGAR
            NSUInteger index = 0;
            if (self.intervalTimeBitR == i+1) {
                for (NSNumber *myBitR in bitRList) {
                    [bitRList replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
                }
            }
            
            NSString *actionMemory = [self.actionsMemoryReference objectAtIndex:i];
            NSInteger bitR;
            if (i < bitRList.count) {
                bitR = [[bitRList objectAtIndex:i] integerValue];
            }
            
            // *** MAIN BLOCK ***
            if ([loadPages containsObject:actionMemory]) {              // SE NO FRAME EXISTE A PAGINA, INCREMENTE HIT E INCREMENTE O BIT R SE  R == 0
                hit++;
                if (bitR == 0) {
                    bitR++;
                }
            }else{                                                       // CASO CONTRÁRIO, ADICIONE A PAGINA NO FRAME E INCREMENTE O BIT R SE R == 0
                fault++;
                if (loadPages.count == frame.integerValue) {             // SE O FRAME ESTIVER CHEIO, PASSE NA LISTA E VERIFIQUE SE O BIT R == 1; 
                                                                         // SE SIM, ZERE O BIT R E COLOQUE NO FINAL DA LISTA... CASO CONTRARIO, REMOVA O OBJETO.
                                                                         // FINALMENTE, COLOQUE O NOVO ELEMENTO NA CABEÇA DA LISTA COM BIT R = 1
                    
                    // GET THE INDEX OF FRAME WILL DELETED
                    NSMutableArray *bitRListCopy = [[NSMutableArray alloc] initWithArray:bitRList];
                    NSInteger indexOfFrameWillDeleted;
                    NSUInteger index = 0;
                    for (NSNumber *myBitR in bitRListCopy) {
                        if (myBitR == 0) {
                            indexOfFrameWillDeleted = index;
                            break;
                        }else{
                            [bitRList replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
                        }
                        index++;
                        
                        if (index == bitRList.count - 1) {
                            indexOfFrameWillDeleted = 0;
                        }
                    }
                    /**FRAME SNAPSHOT**/ [framePage replaceObjectAtIndex:[framePage indexOfObject:[loadPages objectAtIndex:indexOfFrameWillDeleted]] withObject:actionMemory];
                    [loadPages removeObjectAtIndex:indexOfFrameWillDeleted];
                    
                }else{
                    /**FRAME SNAPSHOT**/ [framePage addObject:actionMemory];
                }
                
                [loadPages addObject:actionMemory];
                [bitRList addObject:[NSNumber numberWithInt:1]];
            }
            
            // FINAL DA ITERACAO - LOAD PAGES E O BIT R
            for (int i = 0 ; i < loadPages.count ; i++) {
                NSLog(@">>>LISTA ENCADEADA (%d) %@ R=%d ",i, [loadPages objectAtIndex:i],[[bitRList objectAtIndex:i]integerValue]);
            }
            NSLog(@"Number of hits: %d",hit);
        
            // FINAL DA ITERACAO - O FRAME SNAPSHOT 
            for (int i = 0 ; i < framePage.count ; i++) {
                NSLog(@">>>FRAME SNAPSHOT (%d) %@ ",i, [framePage objectAtIndex:i]);
            }
        
        }
        
        // Final Result
        NSLog(@"Number of hits %d and fault %d",hit,fault);
        for (int i = 0 ; i < loadPages.count ; i++) {
            NSLog(@">>> (%d) %@ ",i, [loadPages objectAtIndex:i]);
        }
        
        for (int i = 0 ; i < framePage.count ; i++) {
            NSLog(@">>>FRAME SNAPSHOT (%d) %@ ",i, [framePage objectAtIndex:i]);
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
