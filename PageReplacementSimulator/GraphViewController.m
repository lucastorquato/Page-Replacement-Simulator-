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

@interface GraphViewController ()

@end

@implementation GraphViewController

#define MAJOR_INCREMENT_Y 2
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
	
    self.fifo = [[PRFifo alloc] init];
    self.fifo.actionsMemoryReference = self.actionsMemoryReference;
    self.fifo.intervalFrames = self.intervalFrames;
    [self.fifo run];
    
    self.secondChance = [[PRSecondChance alloc] init];
    self.secondChance.actionsMemoryReference = self.actionsMemoryReference;
    self.secondChance.intervalFrames = self.intervalFrames;
    self.secondChance.intervalTimeBitR = self.intervalTimeBitR;
    [self.secondChance run];
    
    self.mru = [[PRMru alloc] init];
    self.mru.actionsMemoryReference = self.actionsMemoryReference;
    self.mru.intervalFrames = self.intervalFrames;
    [self.mru run];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Actions

- (IBAction)didTouchDoneButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - UIViewController lifecycle methods
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlot];
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
	//self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
	//self.hostView.allowPinchScaling = YES;
	//[self.view addSubview:self.hostView];
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
	//NSString *title = @"Portfolio Prices: April 2012";
	//graph.title = title;
	// 3 - Create and set text style
	CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
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
	CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
	aaplPlot.dataSource = self;
	//aaplPlot.identifier = CPDTickerSymbolAAPL;
    aaplPlot.identifier = @"FIFO";
	CPTColor *aaplColor = [CPTColor redColor];
	[graph addPlot:aaplPlot toPlotSpace:plotSpace];
	CPTScatterPlot *googPlot = [[CPTScatterPlot alloc] init];
	googPlot.dataSource = self;
	googPlot.identifier = @"SECOND_CHACE";
	CPTColor *googColor = [CPTColor greenColor];
	[graph addPlot:googPlot toPlotSpace:plotSpace];
	CPTScatterPlot *msftPlot = [[CPTScatterPlot alloc] init];
	msftPlot.dataSource = self;
	msftPlot.identifier = @"MRU";
	CPTColor *msftColor = [CPTColor blueColor];
	[graph addPlot:msftPlot toPlotSpace:plotSpace];
	// 3 - Set up plot space
	//[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, googPlot, msftPlot, nil]];
	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot, googPlot,nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
	[xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
	plotSpace.xRange = xRange;
	CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
	[yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
	plotSpace.yRange = yRange;
	// 4 - Create styles and symbols
	CPTMutableLineStyle *aaplLineStyle = [aaplPlot.dataLineStyle mutableCopy];
	aaplLineStyle.lineWidth = 2.5;
	aaplLineStyle.lineColor = aaplColor;
	aaplPlot.dataLineStyle = aaplLineStyle;
	CPTMutableLineStyle *aaplSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	aaplSymbolLineStyle.lineColor = aaplColor;
	CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	aaplSymbol.fill = [CPTFill fillWithColor:aaplColor];
	aaplSymbol.lineStyle = aaplSymbolLineStyle;
	aaplSymbol.size = CGSizeMake(6.0f, 6.0f);
	aaplPlot.plotSymbol = aaplSymbol;
	CPTMutableLineStyle *googLineStyle = [googPlot.dataLineStyle mutableCopy];
	googLineStyle.lineWidth = 1.0;
	googLineStyle.lineColor = googColor;
	googPlot.dataLineStyle = googLineStyle;
	CPTMutableLineStyle *googSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	googSymbolLineStyle.lineColor = googColor;
	CPTPlotSymbol *googSymbol = [CPTPlotSymbol starPlotSymbol];
	googSymbol.fill = [CPTFill fillWithColor:googColor];
	googSymbol.lineStyle = googSymbolLineStyle;
	googSymbol.size = CGSizeMake(6.0f, 6.0f);
	googPlot.plotSymbol = googSymbol;
	CPTMutableLineStyle *msftLineStyle = [msftPlot.dataLineStyle mutableCopy];
	msftLineStyle.lineWidth = 2.0;
	msftLineStyle.lineColor = msftColor;
	msftPlot.dataLineStyle = msftLineStyle;
	CPTMutableLineStyle *msftSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	msftSymbolLineStyle.lineColor = msftColor;
	CPTPlotSymbol *msftSymbol = [CPTPlotSymbol diamondPlotSymbol];
	msftSymbol.fill = [CPTFill fillWithColor:msftColor];
	msftSymbol.lineStyle = msftSymbolLineStyle;
	msftSymbol.size = CGSizeMake(6.0f, 6.0f);
	msftPlot.plotSymbol = msftSymbol;
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
	//CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];    //***** FRAME INTERVALS -  Y AXIS
	CGFloat dateCount = self.fifo.intervalFrames.count;
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
	NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
	NSInteger i = 0;
	//for (NSString *date in [[CPDStockPriceStore sharedInstance] datesInMonth]) {
    for (NSString *date in self.fifo.intervalFrames) {
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
//	NSInteger majorIncrement = 100;
//	NSInteger minorIncrement = 50;
    NSInteger majorIncrement = MAJOR_INCREMENT_Y;
	NSInteger minorIncrement = MINOR_INCREMENT_Y;
	//CGFloat yMax = 700.0f;  // should determine dynamically based on max price //*** MAX HEIGHT VALUE!!!!!!!!!
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
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	//return [[[CPDStockPriceStore sharedInstance] datesInMonth] count];    //*** NUMBER OF FRAME INTERVALS
    return self.intervalFrames.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	//NSInteger valueCount = [[[CPDStockPriceStore sharedInstance] datesInMonth] count];
	NSInteger valueCount = self.intervalFrames.count;
    switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
				return [NSNumber numberWithUnsignedInteger:index];
			}
			break;
			
		case CPTScatterPlotFieldY:
//			if ([plot.identifier isEqual:CPDTickerSymbolAAPL] == YES) {
//				return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolAAPL] objectAtIndex:index];
//			} else if ([plot.identifier isEqual:CPDTickerSymbolGOOG] == YES) {
//				return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolGOOG] objectAtIndex:index];
//			} else if ([plot.identifier isEqual:CPDTickerSymbolMSFT] == YES) {
//				return [[[CPDStockPriceStore sharedInstance] monthlyPrices:CPDTickerSymbolMSFT] objectAtIndex:index];
//			}
            
            if ([plot.identifier isEqual:@"FIFO"]) {
            
                return [self.fifo.allHits objectAtIndex:index];
            
            }else if ([plot.identifier isEqual:@"SECOND_CHACE"]) {
                
                return [self.secondChance.allHits objectAtIndex:index];
            
            }else if ([plot.identifier isEqual:@"MRU"]) {
                
                return [self.mru.allHits objectAtIndex:index];
                
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
    
    return [[allHitsList valueForKeyPath:@"@max.intValue"] intValue];
}

@end
