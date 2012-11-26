//
//  GraphViewController.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 04/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "GraphViewController.h"

#import "CPDConstants.h"
#import "CPDStockPriceStore.h"

#import "PRFifo.h"
#import "PRSecondChance.h"
#import "PRMru.h"
#import "PRNur.h"

#import "ResultTableViewController.h"
#import "MainViewController.h"

#import "DejalActivityView.h"


@interface GraphViewController ()

@end

@implementation GraphViewController

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define MAJOR_INCREMENT_Y 1
#define MINOR_INCREMENT_Y 1 

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
    
    if (IS_IPAD) {
        [self performSelector:@selector(showMainView) withObject:self afterDelay:0.5];
    }else{
        [self runAllPageRepacementAlgo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Main View Delegate

- (void)showMainView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:[NSBundle mainBundle]];
    MainViewController *mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewID"];
    mainViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    mainViewController.delegate = self;
    [self.navigationController presentModalViewController:mainViewController animated:YES];
}

- (void)inputProblemWithActions:(NSArray *)actionsMemory intervalFrames:(NSArray *)intervalFrames andIntervalTimeBitR:(NSInteger)intervalTimeR
{
    self.actionsMemoryReference = actionsMemory;
    self.intervalFrames = intervalFrames;
    self.intervalTimeBitR = intervalTimeR;
    
    [self runAllPageRepacementAlgo];
}

#pragma mark - Run Alg

- (void)runAllPageRepacementAlgo
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Rodando os Algoritmos..."];
    
    //NSMutableArray *actionsMemoryReferenceClean = [[NSMutableArray alloc] initWithArray:[self removeWriteOrReadActionsOnActionsMemory:self.actionsMemoryReference]];
    
    self.fifo = [[PRFifo alloc] init];
    self.fifo.actionsMemoryReference = self.actionsMemoryReference;//actionsMemoryReferenceClean;
    self.fifo.intervalFrames = self.intervalFrames;
    [self.fifo run];
    
    self.secondChance = [[PRSecondChance alloc] init];
    self.secondChance.actionsMemoryReference = self.actionsMemoryReference;//actionsMemoryReferenceClean;
    self.secondChance.intervalFrames = self.intervalFrames;
    self.secondChance.intervalTimeBitR = self.intervalTimeBitR;
    [self.secondChance run];
    
    self.mru = [[PRMru alloc] init];
    self.mru.actionsMemoryReference = self.actionsMemoryReference; //actionsMemoryReferenceClean;
    self.mru.intervalFrames = self.intervalFrames;
    [self.mru run];
    
    self.nur = [[PRNur alloc] init];
    self.nur.actionsMemoryReference = self.actionsMemoryReference;
    self.nur.intervalFrames = self.intervalFrames;
    self.nur.intervalTimeBitR = self.intervalTimeBitR;
    [self.nur run];
    
    [DejalBezelActivityView removeViewAnimated:YES];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Plotando os Dados..."];
    
    [self initPlot];
}

#pragma mark - Actions

- (IBAction)didTouchDoneButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ResultTableSegue"]) {
        ResultTableViewController *resultTableViewController = [segue destinationViewController];
        resultTableViewController.intervalFrames = self.intervalFrames;
        resultTableViewController.fifo = self.fifo;
        resultTableViewController.secondChance = self.secondChance;
        resultTableViewController.mru = self.mru;
        resultTableViewController.nur = self.nur;
    }else if ([segue.identifier isEqualToString:@"MainViewSegue"]){
        MainViewController *mainViewController = [segue destinationViewController];
        mainViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        mainViewController.delegate = self;
    }

}

#pragma mark - Utils

- (NSArray*)removeWriteOrReadActionsOnActionsMemory:(NSArray*)actionsMemory
{
    NSMutableArray *newActionsMemory = [[NSMutableArray alloc] init];
    for (NSString *action in actionsMemory) {
        if (action.length == 2) {
            [newActionsMemory addObject:[action substringToIndex:1]];
        }else{
            [newActionsMemory addObject:[action substringToIndex:2]];
        }
    }
    
    return [NSArray arrayWithArray:newActionsMemory];
}


#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot
{
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    
    [DejalBezelActivityView removeViewAnimated:YES];
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
	//NSString *title = @"Portfolio Prices: April 2012";
	//graph.title = title;
	// 3 - Create and set text style
//	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
//	titleStyle.color = [CPTColor whiteColor];
//	titleStyle.fontName = @"Helvetica-Bold";
//	titleStyle.fontSize = 16.0f;
//	graph.titleTextStyle = titleStyle;
//	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
//	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
	// 4 - Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:30.0f];
	[graph.plotAreaFrame setPaddingBottom:30.0f];
	// 5 - Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
	// 1 - Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	
    // 2 - Create the three plots
	CPTScatterPlot *fifoPlot = [[CPTScatterPlot alloc] init];
	fifoPlot.dataSource = self;
	//aaplPlot.identifier = CPDTickerSymbolAAPL;
    fifoPlot.identifier = @"FIFO";
	CPTColor *fifoColor = [CPTColor greenColor];
	[graph addPlot:fifoPlot toPlotSpace:plotSpace];
	CPTScatterPlot *secondChancePlot = [[CPTScatterPlot alloc] init];
	secondChancePlot.dataSource = self;
	secondChancePlot.identifier = @"SECOND_CHANCE";
	CPTColor *secondChanceColor = [CPTColor purpleColor];
	[graph addPlot:secondChancePlot toPlotSpace:plotSpace];
	CPTScatterPlot *msftPlot = [[CPTScatterPlot alloc] init];
	msftPlot.dataSource = self;
	msftPlot.identifier = @"MRU";
	CPTColor *msftColor = [CPTColor redColor];
	[graph addPlot:msftPlot toPlotSpace:plotSpace];
    CPTScatterPlot *nurPlot = [[CPTScatterPlot alloc] init];
	nurPlot.dataSource = self;
	nurPlot.identifier = @"NUR";
	CPTColor *nurColor = [CPTColor yellowColor];
	[graph addPlot:nurPlot toPlotSpace:plotSpace];
    
    
	// 3 - Set up plot space
	//[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, googPlot, msftPlot, nil]];
	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:fifoPlot, secondChancePlot, msftPlot, nurPlot,nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)]; //1.1f
	plotSpace.xRange = xRange;
	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)]; //1.2f
	plotSpace.yRange = yRange;
	
    // 4 - Create styles and symbols
	CPTMutableLineStyle *fifoLineStyle = [fifoPlot.dataLineStyle mutableCopy];
	fifoLineStyle.lineWidth = 4.0;
	fifoLineStyle.lineColor = fifoColor;
	fifoPlot.dataLineStyle = fifoLineStyle;
	CPTMutableLineStyle *fifoSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	fifoSymbolLineStyle.lineColor = fifoColor;
	CPTPlotSymbol *fifoSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	fifoSymbol.fill = [CPTFill fillWithColor:fifoColor];
	fifoSymbol.lineStyle = fifoSymbolLineStyle;
	fifoSymbol.size = CGSizeMake(6.0f, 6.0f);
	fifoPlot.plotSymbol = fifoSymbol;
	CPTMutableLineStyle *secondChanceLineStyle = [secondChancePlot.dataLineStyle mutableCopy];
	secondChanceLineStyle.lineWidth = 4.0;
	secondChanceLineStyle.lineColor = secondChanceColor;
	secondChancePlot.dataLineStyle = secondChanceLineStyle;
	CPTMutableLineStyle *secondChanceSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	secondChanceSymbolLineStyle.lineColor = secondChanceColor;
	CPTPlotSymbol *secondChanceSymbol = [CPTPlotSymbol starPlotSymbol];
	secondChanceSymbol.fill = [CPTFill fillWithColor:secondChanceColor];
	secondChanceSymbol.lineStyle = secondChanceSymbolLineStyle;
	secondChanceSymbol.size = CGSizeMake(6.0f, 6.0f);
	secondChancePlot.plotSymbol = secondChanceSymbol;
	CPTMutableLineStyle *msftLineStyle = [msftPlot.dataLineStyle mutableCopy];
	msftLineStyle.lineWidth = 4.0;
	msftLineStyle.lineColor = msftColor;
	msftPlot.dataLineStyle = msftLineStyle;
	CPTMutableLineStyle *msftSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	msftSymbolLineStyle.lineColor = msftColor;
	CPTPlotSymbol *msftSymbol = [CPTPlotSymbol diamondPlotSymbol];
	msftSymbol.fill = [CPTFill fillWithColor:msftColor];
	msftSymbol.lineStyle = msftSymbolLineStyle;
	msftSymbol.size = CGSizeMake(6.0f, 6.0f);
	msftPlot.plotSymbol = msftSymbol;
    CPTMutableLineStyle *nurLineStyle = [nurPlot.dataLineStyle mutableCopy];
	nurLineStyle.lineWidth = 4.0;
	nurLineStyle.lineColor = nurColor;
    nurLineStyle.lineJoin =  kCGLineCapRound;
    nurLineStyle.lineCap = kCGLineCapButt;
	nurPlot.dataLineStyle = nurLineStyle;
	CPTMutableLineStyle *nurSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	nurSymbolLineStyle.lineColor = nurColor;
	CPTPlotSymbol *nurSymbol = [CPTPlotSymbol diamondPlotSymbol];
	nurSymbol.fill = [CPTFill fillWithColor:nurColor];
	nurSymbol.lineStyle = nurSymbolLineStyle;
	nurSymbol.size = CGSizeMake(6.0f, 6.0f);
	nurPlot.plotSymbol = nurSymbol;
}

-(void)configureAxes {
	// 1 - Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";
	axisTextStyle.fontSize = 11.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 2.0f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 1.0f;
	// 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
	CPTAxis *x = axisSet.xAxis;
	x.title = @"Number of Frames";
	x.titleTextStyle = axisTitleStyle;
	x.titleOffset = 15.0f;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	x.labelTextStyle = axisTextStyle;
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.tickDirection = CPTSignNegative;
	CGFloat dateCount = self.intervalFrames.count;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
	NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
	NSInteger i = 0;

    for (NSString *date in self.intervalFrames) {
		CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
		CGFloat location = i++;
		label.tickLocation = CPTDecimalFromCGFloat(location);
		label.offset = x.majorTickLength;
		if (label) {
			[xLabels addObject:label];
			[xLocations addObject:[NSNumber numberWithFloat:location]];
		}
	}
	x.axisLabels = xLabels;
	x.majorTickLocations = xLocations;
	// 4 - Configure y-axis
	CPTAxis *y = axisSet.yAxis;
	y.title = @"Hit";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -40.0f;
	y.axisLineStyle = axisLineStyle;
	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 16.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 4.0f;
	y.minorTickLength = 2.0f;
	y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = [self getMaxHitValueWithAllPGAlgorithms];
	NSInteger minorIncrement = [self getMinHitValueWithAllPGAlgorithms];
	CGFloat yMax = [self getMaxHitValueWithAllPGAlgorithms];
    NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
	for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
		NSUInteger mod = j % majorIncrement;
		if (mod == 0) {
			CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
			NSDecimal location = CPTDecimalFromInteger(j);
			label.tickLocation = location;
			label.offset = -y.majorTickLength - y.labelOffset;
			if (label) {
				[yLabels addObject:label];
			}
			[yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
		} else {
			[yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
		}
	}
	y.axisLabels = yLabels;
	y.majorTickLocations = yMajorLocations;
	y.minorTickLocations = yMinorLocations;
    
//    for (NSDecimalNumber *number in yMajorLocations) {
//        NSLog(@"MAJOR: %@",number);
//    }
//    
//    for (NSDecimalNumber *number in yMinorLocations) {
//        NSLog(@"MINOR: %@",number);
//    }
}


#pragma mark - CPTPlotDataSource methods

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return self.intervalFrames.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	
	NSInteger valueCount = self.intervalFrames.count;
    
    switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
				return [NSNumber numberWithUnsignedInteger:index];
			}
			break;
			
		case CPTScatterPlotFieldY:
            
            if ([plot.identifier isEqual:@"FIFO"]) {
            
                return [self.fifo.allHits objectAtIndex:index];
            
            }else if ([plot.identifier isEqual:@"SECOND_CHANCE"]) {
                
                return [self.secondChance.allHits objectAtIndex:index];
            
            }else if ([plot.identifier isEqual:@"MRU"]) {
                
                return [self.mru.allHits objectAtIndex:index];
                
            }else if ([plot.identifier isEqual:@"NUR"]){
            
                return [self.nur.allHits objectAtIndex:index];
                
            }
            
            
			break;
	}
	return [NSDecimalNumber zero];
}


#pragma mark - Utils

- (NSUInteger)getMaxHitValueWithAllPGAlgorithms
{
    NSMutableArray *allHitsList = [[NSMutableArray alloc] init];
    [allHitsList addObject:[self.fifo.allHits valueForKeyPath:@"@max.intValue"]];
    [allHitsList addObject:[self.secondChance.allHits valueForKeyPath:@"@max.intValue"]];
    [allHitsList addObject:[self.mru.allHits valueForKeyPath:@"@max.intValue"]];
    [allHitsList addObject:[self.nur.allHits valueForKeyPath:@"@max.intValue"]];
    
    return [[allHitsList valueForKeyPath:@"@max.intValue"] intValue];
}

- (NSUInteger)getMinHitValueWithAllPGAlgorithms
{
    NSMutableArray *allHitsList = [[NSMutableArray alloc] init];
    [allHitsList addObject:[self.fifo.allHits valueForKeyPath:@"@min.intValue"]];
    [allHitsList addObject:[self.secondChance.allHits valueForKeyPath:@"@min.intValue"]];
    [allHitsList addObject:[self.mru.allHits valueForKeyPath:@"@min.intValue"]];
    [allHitsList addObject:[self.nur.allHits valueForKeyPath:@"@min.intValue"]];
    
    return [[allHitsList valueForKeyPath:@"@min.intValue"] intValue];
}

@end
