//
//  dMusicTableViewController.m
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-08-05.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "dMusicTableViewController.h"

@interface dMusicTableViewController ()
@property (strong, nonatomic) NSMutableArray *songsList;

@end

@implementation dMusicTableViewController

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
	MPMediaQuery *everything = [[MPMediaQuery alloc] init];
	NSArray *itemsFromGenericQuery = [everything items];
	self.songsList = [NSMutableArray arrayWithArray:itemsFromGenericQuery];
	//3
	[self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.songsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"MusicCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	self->song = [self.songsList objectAtIndex:indexPath.row];
	NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
	NSString *durationLabel = [song valueForProperty: MPMediaItemPropertyGenre];
	cell.textLabel.text = songTitle;
	cell.detailTextLabel.text = durationLabel;
	return cell;
}

#pragma mark - TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self->song = [self.songsList objectAtIndex:indexPath.row];
	[[self delegate] setTrack:self->song];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillDisappear:(BOOL) animated {
}


@end
