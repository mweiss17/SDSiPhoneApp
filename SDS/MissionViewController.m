//
//  MissionViewController.m
//  SDS
//
//  Created by Martin Weiss 1 on 2014-04-28.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//
#import "SDSAppDelegate.h"
#import "MissionViewController.h"
#import "EventViewController.h"
@interface MissionViewController ()

@end

@implementation MissionViewController{
	NSArray *jsonArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.EventTable.dataSource = self;
	self.EventTable.delegate = self;
	[self sendHTTPGetFunc];
}

-(void) sendHTTPGetFunc
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://54.187.196.187/appindex.html/"];
	
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		 if(error == nil)
		 {
			 //NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
			 
			 jsonArray = [NSJSONSerialization JSONObjectWithData:data
																options:kNilOptions
																		error:&error];
			 for(NSDictionary *item in jsonArray) {
			 }

		 }
		[self.EventTable reloadData];
	 }];
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [jsonArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Initialize Cell
    static NSString *tableID = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
    }
	NSDictionary *jsonDict = [jsonArray objectAtIndex:indexPath.row];

	//set cell title
	NSString *title = [jsonDict objectForKey:@"title"];
	cell.textLabel.text = title;

	//set cell detail (start Time)
	NSString *d = [jsonDict objectForKey:@"start"];
	float date = [d floatValue];
	
	NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	NSString *myDateString = [dateFormatter stringFromDate:messageDate];
	cell.detailTextLabel.text = myDateString;

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	self->dest = [segue destinationViewController];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *jsonDict = [jsonArray objectAtIndex:indexPath.row];
	NSString *latdat = [jsonDict objectForKey:@"latitude"];
	NSString *longdat = [jsonDict objectForKey:@"longitude"];
	NSString *title = [jsonDict objectForKey:@"title"];
	NSString *location = [jsonDict objectForKey:@"location"];

	dest->title = title;
	dest->location = location;
	dest->latitude = [latdat floatValue];
	dest->longitude = [longdat floatValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
