//
//  PRNru.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 10/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "PRNur.h"

@implementation PRNur

- (void)run
{
    
    if (!self.allHits) {
        self.allHits = [[NSMutableArray alloc] init];
    }
    
    for (NSString *frame in self.intervalFrames) {
        
        int hit = 0;
        int fault = 0;
        
        NSMutableArray *framePage =[[NSMutableArray alloc] initWithCapacity:frame.integerValue];  // FRAME SNAPSHOT
        
        NSMutableArray *loadPages = [[NSMutableArray alloc] initWithCapacity:frame.integerValue]; // LISTA DUPLAMENTE ENCADEADA
        
        NSMutableArray *bitRList = [[NSMutableArray alloc] initWithCapacity:frame.integerValue];  // LISTA DE BIT R
        
        NSMutableArray *bitMList = [[NSMutableArray alloc] initWithCapacity:frame.integerValue];  // LISTA DE BIT M
        
        for (int i = 0 ; i < self.actionsMemoryReference.count ; i++) {
            
            // COLOCAR TODOS OS BIT R EM ZERO QUANDO O NUMERO DE ACOES CHEGAR
            
            NSMutableArray *bitRListCopy = [[NSMutableArray alloc] initWithArray:bitRList];
            if (self.intervalTimeBitR == i) {
                for (int x = 0; x < bitRListCopy.count; x++) {
                    [bitRList replaceObjectAtIndex:x withObject:[NSNumber numberWithInt:0]];
                }
            }
            
            
            NSString *actionMemory = [[self.actionsMemoryReference objectAtIndex:i] substringToIndex:1];
            NSString *actionRorW = [[self.actionsMemoryReference objectAtIndex:i] substringFromIndex:1];
            
            // *** MAIN BLOCK ***
            if ([loadPages containsObject:actionMemory]) {   // SE NO FRAME EXISTE A PAGINA, INCREMENTE HIT; INCREMENTE O BIT R SE R == 0 ; INCREMENTE M SE A ACAO FOR ESCRITA E SE M ==0
                hit++;
                if ([[bitRList objectAtIndex:[loadPages indexOfObject:actionMemory]]integerValue] == 0) {
                    [bitRList replaceObjectAtIndex:[loadPages indexOfObject:actionMemory] withObject:[NSNumber numberWithInt:1]];
                }
                
                if ([actionRorW isEqualToString:@"W"] && [[bitMList objectAtIndex:[loadPages indexOfObject:actionMemory]]integerValue] == 0) {
                    [bitMList replaceObjectAtIndex:[loadPages indexOfObject:actionMemory] withObject:[NSNumber numberWithInt:1]];
                }
                
            }else{                                                       // CASO CONTRÁRIO,
                fault++;
                if (loadPages.count == frame.integerValue) {             // SE O FRAME ESTIVER CHEIO, PASSE NA LISTA E REMOVA O FRAME COM A CLASSE MAIS BAIXA E DEPOIS ADICIONE O NOVO FRAME
                                                                         // SE NÃO, ADICIONE O NOVO FRAME NO FINAL DA LISTA
                    
                    // GET THE INDEX OF FRAME WILL DELETED
                    NSInteger indexOfFrameWillDeleted;
                    NSMutableArray *classesOfFrames = [[NSMutableArray alloc] init];
                    for (int i = 0; i < bitRList.count; i++) {
                        NSInteger myBitR = [[bitRList objectAtIndex:i]integerValue];
                        NSInteger myBitM = [[bitMList objectAtIndex:i]integerValue];
                        
                        [classesOfFrames addObject:[NSNumber numberWithInteger:[self geClassOfFrameWithBitR:myBitR andBitM:myBitM]]];
                    }
                    
                    indexOfFrameWillDeleted = [classesOfFrames indexOfObject:[classesOfFrames valueForKeyPath:@"@min.self"]];
    
                    
                    NSLog(@"Number of hits: %d",hit);
                    for (int i = 0 ; i < loadPages.count ; i++) {
                        NSLog(@">>>LISTA ENCADEADA (%d) %@ R=%d M=%d",i, [loadPages objectAtIndex:i],[[bitRList objectAtIndex:i]integerValue],[[bitMList objectAtIndex:i]integerValue]);
                    }
                    NSLog(@"DELETE: index %d - object %@",indexOfFrameWillDeleted, [loadPages objectAtIndex:indexOfFrameWillDeleted]);
                    
                    
                    /**FRAME SNAPSHOT**/ [framePage replaceObjectAtIndex:[framePage indexOfObject:[loadPages objectAtIndex:indexOfFrameWillDeleted]] withObject:actionMemory];
                    [loadPages removeObjectAtIndex:indexOfFrameWillDeleted];
                    [bitRList removeObjectAtIndex:indexOfFrameWillDeleted];
                    [bitMList removeObjectAtIndex:indexOfFrameWillDeleted];
                }else{
                    /**FRAME SNAPSHOT**/ [framePage addObject:actionMemory];
                }
                [loadPages addObject:actionMemory];
                [bitRList addObject:[NSNumber numberWithInt:1]];
                if ([actionRorW isEqualToString:@"W"]) {
                    [bitMList addObject:[NSNumber numberWithInt:1]];
                }else{
                    [bitMList addObject:[NSNumber numberWithInt:0]];
                }
            }
            
            // FINAL DA ITERACAO - LOAD PAGES E O BIT R
            for (int i = 0 ; i < loadPages.count ; i++) {
                NSLog(@">>>LISTA ENCADEADA (%d) %@ R=%d M=%d",i, [loadPages objectAtIndex:i],[[bitRList objectAtIndex:i]integerValue],[[bitMList objectAtIndex:i]integerValue]);
            }
            NSLog(@"Number of hits: %d",hit);
            
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
    
    for (NSString *hit in self.allHits) {
        NSLog(@"%@",hit);
    }
}

#pragma mark - Utils

- (NSInteger)geClassOfFrameWithBitR:(NSInteger)bitR andBitM:(NSInteger)bitM;
{
    if (bitR == 0 && bitM == 0) {
        return 0;
    }else if (bitR == 0 && bitM == 1){
        return 1;
    }else if (bitR == 1 && bitM == 0){
        return 2;
    }else if (bitR == 1 && bitM == 1){
        return 3;
    }
    return 0;
}

@end
