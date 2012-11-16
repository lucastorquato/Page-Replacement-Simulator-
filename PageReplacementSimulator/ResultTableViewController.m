//
//  ResultTableViewController.m
//  PageReplacementSimulator
//
//  Created by Lucas Torquato on 15/11/12.
//  Copyright (c) 2012 Lucas Torquato. All rights reserved.
//

#import "ResultTableViewController.h"
#import "HeaderViewController.h"
#import "ResultCell.h"
#import "PRFifo.h"
#import "PRSecondChance.h"
#import "PRMru.h"
#import "PRNur.h"

@interface ResultTableViewController ()

@end

@implementation ResultTableViewController

@synthesize fifo, secondChance, mru, nur, intervalFrames;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.intervalFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultCell";
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.numberOfFramesLabel.text = [self.intervalFrames objectAtIndex:indexPath.row];
    cell.hitFifoLabel.text = [self.fifo.allHits objectAtIndex:indexPath.row];
    cell.hitSecondChanceLabel.text = [self.secondChance.allHits objectAtIndex:indexPath.row];
    cell.hitMRULabel.text = [self.mru.allHits objectAtIndex:indexPath.row];
    cell.hitNURLabel.text = [self.nur.allHits objectAtIndex:indexPath.row];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderViewController *headerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HeaderView"];
    return headerViewController.view;
}

@end
