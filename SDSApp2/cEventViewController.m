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
	
	NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
	
    // Change the default output audio route
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
							sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);

	
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
}

/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
/////////////////// PLAYER VIEW STUFF ////*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/


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

}

- (void) createTimeLabels{
	self->playtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 100, 20)];
	self->durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 75, 100, 20)];
	[self->volumeView addSubview:playtimeLabel];
	[self->volumeView addSubview:durationLabel];
	[self->volumeView bringSubviewToFront:playtimeLabel];
}


/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
//////////// PLAYER PROGRAMMATIC STUFF ///*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/
- (void) pickTrack{
	[self performSegueWithIdentifier:@"pickTrack" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	dMusicTableViewController *childVC = segue.destinationViewController;
	childVC.delegate = self;
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
	self->discoTrack = [autoResults objectAtIndex:0];
	[self loadAndPlayLocalTrack];
}

- (void) loadAndPlayLocalTrack{
	[self createTimeLabels];
	songURL = [self->discoTrack valueForProperty:MPMediaItemPropertyAssetURL];
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
		NSLog(@"Stream.");
		//Get the Stream URL
		NSURL *url = [NSURL URLWithString:streamURL];
		self->avAsset = [AVURLAsset URLAssetWithURL:url options:nil];
		self->playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
		self->player = [AVPlayer playerWithPlayerItem:playerItem];
		[self->player play];
		[self createTimeLabels];
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
    else if([title isEqualToString:@"Pick Track to Synchronize"])
    {
        NSLog(@"Pick Track to Synchronize.");
		[self pickTrack];
    }
}

- (void) updateSlider{
	AVPlayerItem *currentItem = player.currentItem;
	Float64 currentTime = CMTimeGetSeconds(currentItem.currentTime); //playing time
	Float64 duration = CMTimeGetSeconds(currentItem.duration); //total time
	
	//create a pair of labels
	self->playtimeLabel.text = [self floatToText:currentTime];
	self->durationLabel.text = [self floatToText:duration];
	self->slider.value = currentTime/duration;
}

-(NSMutableString*) floatToText: (Float64)time{
	NSString *hours = [NSString stringWithFormat:@"%uh ", (int) time/3600];
	time = (int)time % 3600;
	NSString *mins = [NSString stringWithFormat:@"%um ", (int) time/60];
	time = (int)time % 60;
	NSString *seconds = [NSString stringWithFormat:@"%us ", (int) time];
	NSMutableString *timeString = [[NSMutableString alloc] initWithString:hours];
	
	[timeString appendString:mins];
	[timeString appendString:seconds];
	return timeString;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
		[self.navigationController setNavigationBarHidden:YES];   //it hides
    }
    [super viewWillDisappear:animated];
}

//delegate function implemented
//this gets called from the second viewconroller when the view disappears
- (void) setTrack:(MPMediaItem *)song
{
	self->discoTrack = song;
	[self loadAndPlayLocalTrack];
}


/*****************************************************/
///////////////////////// //////////////////*//////////
///////////////////////      //////////////*///////////
/////////////////// MAP VIEW STUFF ///////*////////////
///////////////////////      ////////////*/////////////
///////////////////////// //////////////*//////////////
/*****************************************************/

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

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end