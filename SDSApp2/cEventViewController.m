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
	[self.navigationController setNavigationBarHidden:NO];   //it hides
	locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
	self->setSpan = FALSE;
	
	[self initializeMapView];
	[self createMapView];
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

- (void) pickTrack{
	//Open a new tableview with all the songs
	[self performSegueWithIdentifier:@"pickTrack" sender:self];
	//Implement search controls
	//Grab the correct song
	// return to the this screen
	

}

- (void)createVolumeView{
	volumeView.backgroundColor = [Common colorWithHexString:@"0EA48B"];
	
	//put the trackname on the view
	UILabel *tracknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
	tracknameLabel.text = self->songTitle;
	tracknameLabel.textAlignment = NSTextAlignmentCenter;
	[tracknameLabel setTextColor:[UIColor whiteColor]];
	[tracknameLabel setBackgroundColor:[UIColor clearColor]];
	[tracknameLabel setFont:[UIFont fontWithName: @"Dosis-Bold" size: 14.0f]];
	[self->volumeView addSubview:tracknameLabel];

	//create slider
	CGRect frame = CGRectMake(30.0, 40.0, 260.0, 10.0);
    self->slider = [[UISlider alloc] initWithFrame:frame];
    //[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    slider.continuous = YES;
    slider.value = 0.0;
    [self->volumeView addSubview:slider];

	//create labels
	self->durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 75, 100, 20)];
	self->playtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 75, 100, 20)];
	[self->volumeView addSubview:playtimeLabel];
	[self->volumeView addSubview:durationLabel];
	[self->volumeView bringSubviewToFront:playtimeLabel];

}

-(void) initializeMapView{
	CGRect r = self.view.bounds;
	r.size.height = 350;
	self->mapView = [[MKMapView alloc] initWithFrame:r];
	mapView.mapType = MKMapTypeStandard;
	mapView.showsUserLocation = YES;
	mapView.userTrackingMode = YES;
}

//grab the user location
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
		  fromLocation:(CLLocation *)oldLocation
{
	self->userLocation = mapView.userLocation;
	self->userlat = newLocation.coordinate.latitude;
	self->userlong = newLocation.coordinate.longitude;
	//only adjust the region of the map once
	if(!self->setSpan){
		self->setSpan = TRUE;
		[self createMapView];
	}
}

- (void)createMapView{
	//create the point for the destination
	CLLocationCoordinate2D coord = {.latitude =  self->latitude, .longitude =  self->longitude};
	MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = self->eventTitle;
    point.subtitle = self->location;
	[self->mapView addAnnotation:point];
	[mapView selectAnnotation:point animated:YES];

	//calculate the size of the region for the map
	CLLocationDegrees latitudeRegion = fabs(userlat-latitude);
	CLLocationDegrees longitudeRegion = fabs(userlong-longitude);
    latitudeRegion = (int)(latitudeRegion*2.5);
	longitudeRegion = (int)(longitudeRegion*2.5);
	latitudeRegion = (int)latitudeRegion%360;
	longitudeRegion = (int)longitudeRegion%360;

	MKCoordinateSpan span = {latitudeRegion, longitudeRegion};
	MKCoordinateRegion region = {{userlat, userlong}, span};
	[mapView setRegion:region];
	
	[self.view addSubview:mapView];
}

- (void)calcTime
{
	NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
	if ([self->player rate] != 0.0){
	}

	self.eta = now - _startprop;
	if(self.eta <0){
		self.eta = -self.eta;
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
		[self pickTrack];
    }
	
}

- (void)updatePlayer{
	if (_eta >= 0){
		[_updatePlayerTimer invalidate];
		_updatePlayerTimer = nil;
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(updateSlider)
									   userInfo:nil
										repeats:YES];
	}
}
- (void) updateSlider{
	AVPlayerItem *currentItem = player.currentItem;
	Float64 currentTime = CMTimeGetSeconds(currentItem.currentTime); //playing time
	Float64 duration = CMTimeGetSeconds(currentItem.duration); //total time
	//create a pair of labels
	self->playtimeLabel.text = [NSString stringWithFormat:@"%f", currentTime];
	self->durationLabel.text = [NSString stringWithFormat:@"%f", duration];
	self->slider.value = currentTime/duration;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
		[self.navigationController setNavigationBarHidden:YES];   //it hides
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end