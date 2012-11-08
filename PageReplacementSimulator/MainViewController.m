//
//  MainViewController.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "MainViewController.h"

#import "GraphViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize intervalTimeBitRTextField;
@synthesize paginationReferencesTextField, firstIntervalFramesTextField, secondIntervalFramesTextField;

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self configureAllTextFields];
    
    self.paginationReferencesTextField.text = @"7W 2W 7R 4W 4R 2R 6R 6R 5W 2W 7R 0R 5W 6W 4R 5R 1R 1W 5W";
    self.firstIntervalFramesTextField.text = @"4";
    self.secondIntervalFramesTextField.text = @"10";
    self.intervalTimeBitRTextField.text = @"10";
}

- (void)viewDidUnload
{
    [self setPaginationReferencesTextField:nil];
    [self setFirstIntervalFramesTextField:nil];
    [self setSecondIntervalFramesTextField:nil];
    [self setIntervalTimeBitRTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Actions

- (IBAction)didTouchRunButton:(id)sender
{
    if (self.paginationReferencesTextField.text.length > 0 && self.firstIntervalFramesTextField.text.length > 0 && self.secondIntervalFramesTextField.text.length > 0) {
        if ([self.firstIntervalFramesTextField.text integerValue] < [self.secondIntervalFramesTextField.text integerValue]) {
            [self performSegueWithIdentifier:@"GraphSegue" sender:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"O Intervalo está errado." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Complete todas as informações." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GraphViewController *graphViewController = [segue destinationViewController];
    graphViewController.actionsMemoryReference = [self getMemoryActionsArrayWithBruteString:self.paginationReferencesTextField.text];
    graphViewController.intervalFrames = [self getAllFrameIntervalsWithFirst:self.firstIntervalFramesTextField.text andSecondInterval:self.secondIntervalFramesTextField.text];
    graphViewController.intervalTimeBitR = [self.intervalTimeBitRTextField.text integerValue];
    
}

#pragma mark - Utils

- (NSArray*)getAllFrameIntervalsWithFirst:(NSString*)firstInterval andSecondInterval:(NSString*)secondInterval
{
    NSMutableArray *allFrameIntervals = [[NSMutableArray alloc] init];
    
    for (int i = firstInterval.integerValue; i < secondInterval.integerValue+1; i++) {
        [allFrameIntervals addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (NSString *interval in allFrameIntervals) {
        NSLog(@"%@",interval);
    }
    
    return [NSArray arrayWithArray:allFrameIntervals];
}

- (NSArray*)getMemoryActionsArrayWithBruteString:(NSString*)memoryActionsStr
{
    NSArray *subStrings = [memoryActionsStr componentsSeparatedByString:@" "];
    for (int i = 0; i < [subStrings count]; i++) {
        NSLog(@"string on array position %d is : %@", i, [subStrings objectAtIndex:i]);
    }
    
    return subStrings;
}

- (void)configureAllTextFields
{
    [self.paginationReferencesTextField setDelegate:self];
    [self.paginationReferencesTextField setReturnKeyType:UIReturnKeyDone];
    [self.paginationReferencesTextField addTarget:self
                                           action:@selector(dismissKeyboard:)
                                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.firstIntervalFramesTextField setDelegate:self];
    [self.firstIntervalFramesTextField setReturnKeyType:UIReturnKeyDone];
    [self.firstIntervalFramesTextField addTarget:self
                                          action:@selector(dismissKeyboard:)
                                forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.secondIntervalFramesTextField setDelegate:self];
    [self.secondIntervalFramesTextField setReturnKeyType:UIReturnKeyDone];
    [self.secondIntervalFramesTextField addTarget:self
                                           action:@selector(dismissKeyboard:)
                                 forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.intervalTimeBitRTextField setDelegate:self];
    [self.intervalTimeBitRTextField setReturnKeyType:UIReturnKeyDone];
    [self.intervalTimeBitRTextField addTarget:self
                                           action:@selector(dismissKeyboard:)
                                 forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)dismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

@end
