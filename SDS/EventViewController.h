//
//  EventViewController.h
//  SDS
//
//  Created by Martin Weiss 1 on 2014-05-17.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface EventViewController : UIViewController{
	MKMapView *mapView;
	@public float latitude;
	@public float longitude;
	@public NSString *title;
	@public NSString *location;
}

@end
