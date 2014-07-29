//
//  cEventViewController.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-23.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
@interface cEventViewController : UIViewController<UIAlertViewDelegate, AVAudioPlayerDelegate>{
	MKMapView *mapView;
	@public float latitude;
	@public float longitude;
	@public NSString *eventTitle;
	@public NSString *songTitle;
	@public NSString *streamURL;
	@public NSString *location;
	@public MPMediaItem *discoTrack;
	IBOutlet UILabel *countdownTimer;
	UIView *playerView;
	AVPlayer *player;
	AVAsset *avAsset;
	AVPlayerItem *playerItem;
	NSURL *songURL;
	NSArray *autoResults;
	IBOutlet UIView *volumeView;
}
@property double startprop;

@property double eta;
@property NSTimer *updatePlayerTimer;
@end
