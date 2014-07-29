//
//  cEventViewController.m
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-23.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "cEventViewController.h"

@interface cEventViewController ()

@end

@implementation cEventViewController

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
	[self createMapView];
	[self createPlayerView];
	[self createVolumeView];
	[self checkForTrack];
	[NSTimer scheduledTimerWithTimeInterval:1.0
									 target:self
								   selector:@selector(calcTime)
								   userInfo:nil
									repeats:YES];
	
	_updatePlayerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
														  target:self
														selector:@selector(updatePlayer)
														userInfo:nil
														 repeats:YES];
	

	
}
- (void)createVolumeView{
	volumeView.backgroundColor = [Common colorWithHexString:@"0EA48B"];
}
- (void)createPlayerView{
	//tell the view where to be
	CGRect r = self.view.bounds;
	r.origin.y = 300;
	r.origin.x = 20;
	r.size.width = 280;
	r.size.height = 100;
	self->playerView = [[UIView alloc] initWithFrame:r];
	playerView.backgroundColor = [Common colorWithHexString:@"000000"];
	
	//put the trackname on the view
	UILabel *tracknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
	tracknameLabel.text = self->songTitle;
	tracknameLabel.textAlignment = NSTextAlignmentCenter;
	[tracknameLabel setTextColor:[UIColor whiteColor]];
	[tracknameLabel setBackgroundColor:[UIColor clearColor]];
	[tracknameLabel setFont:[UIFont fontWithName: @"Dosis-Bold" size: 14.0f]];
	[self->playerView addSubview:tracknameLabel];

	
	[self.view addSubview:playerView];
	[self.view bringSubviewToFront:playerView];

}
- (void)createMapView{
	CGRect r = self.view.bounds;
	r.size.height = 350;
	self->mapView = [[MKMapView alloc] initWithFrame:r];
	mapView.mapType = MKMapTypeStandard;
	mapView.showsUserLocation = YES;
	
	CLLocationCoordinate2D coord = {.latitude =  self->latitude, .longitude =  self->longitude};
	MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
	MKCoordinateRegion region = {coord, span};
	
	[mapView setRegion:region];
	[self.view addSubview:mapView];
	MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = self->eventTitle;
    point.subtitle = self->location;
    
    [self->mapView addAnnotation:point];

}

- (void)calcTime
{
	NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
	if ([self->player rate] != 0.0){
		NSLog(@"playing!!!");
	}

	self.eta = now - _startprop;
	if(self.eta <0){
		self.eta = -self.eta;
		NSLog(@"eta = %f", _eta);
		NSString *hours = [NSString stringWithFormat:@"%uh ", (int) _eta/3600];
		_eta = (int)_eta % 3600;
		NSString *mins = [NSString stringWithFormat:@"%um ", (int) _eta/60];
		_eta = (int)_eta % 60;
		NSString *seconds = [NSString stringWithFormat:@"%us ", (int) _eta];
		
		NSMutableString *time = [[NSMutableString alloc] initWithString:hours];
		
		[time appendString:mins];
		[time appendString:seconds];
		self->countdownTimer.text = time;
		return;
	}
	NSLog(@"eta = %f", _eta);
	NSString *hours = [NSString stringWithFormat:@"%uh ", (int) _eta/3600];
	_eta = (int)_eta % 3600;
	NSString *mins = [NSString stringWithFormat:@"%um ", (int) _eta/60];
	_eta = (int)_eta % 60;
	NSString *seconds = [NSString stringWithFormat:@"%us ", (int) _eta];
	
	NSMutableString *time = [[NSMutableString alloc] initWithString:hours];
	
	[time appendString:mins];
	[time appendString:seconds];
	self->countdownTimer.text = time;
	
}

- (void)checkForTrack
{
	MPMediaPropertyPredicate *songPredicate =
	[MPMediaPropertyPredicate predicateWithValue:songTitle
									 forProperty:MPMediaItemPropertyTitle
								  comparisonType:MPMediaPredicateComparisonContains];
	NSSet *predicates = [NSSet setWithObjects: songPredicate, nil];
	MPMediaQuery *songsQuery =  [[MPMediaQuery alloc] initWithFilterPredicates: predicates];
	self->autoResults = [songsQuery items];
	
	//no song found locally
	if(!([autoResults count] == 0))
	{
		[self foundLocally];
	}
	//found song locally
	else{
		[self notFoundLocally];
	}
}
- (void) notFoundLocally{
	NSString *message = [NSString stringWithFormat:@""];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Not Found", songTitle]														message:message
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:nil];
	
	[alert addButtonWithTitle:@"Stream"];
	[alert addButtonWithTitle:@"Pick Track to Synchronize"];
	[alert show];
}

- (void) foundLocally{
	NSString *message = [NSString stringWithFormat:@"You've got the Track!: %@", songTitle];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sweeeeeeet"
													message:message
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	//found song locally, and play it
	[self loadAndPlayLocalTrack];
}

- (void) loadAndPlayLocalTrack{
	MPMediaItem *song = [autoResults objectAtIndex:0];
	songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
	AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:songURL options:nil];
	NSArray *keyArray = [[NSArray alloc] initWithObjects:@"tracks", nil];
	[urlAsset loadValuesAsynchronouslyForKeys:keyArray completionHandler:^{
		
		AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:urlAsset];
		
		player = nil;
		player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
		
		while (true) {
			if (player.status == AVPlayerStatusReadyToPlay && playerItem.status == AVPlayerItemStatusReadyToPlay)
				break;
		}
		
		[player play];
		
	}];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
    if([title isEqualToString:@"Stream"])
    {
		//Get the Stream URL
		NSURL *url = [NSURL URLWithString:streamURL];
		self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
		self->playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
		self->player = [AVPlayer playerWithPlayerItem:playerItem];
		[self->player play];
    }
    else if([title isEqualToString:@"Pick Track to Synchronize"])
    {
        NSLog(@"Pick Track to Synchronize.");
		//Open a new tableview with all the songs
		//Implement search controls
		//Grab the correct song and return to the other
    }
	
}

- (void)updatePlayer{
	if (_eta >= 0){
		[_updatePlayerTimer invalidate];
		_updatePlayerTimer = nil;
		NSLog(@"delete");
	}
	NSLog(@"still Here");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end