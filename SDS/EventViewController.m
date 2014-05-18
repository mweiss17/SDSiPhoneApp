//
//  EventViewController.m
//  SDS
//
//  Created by Martin Weiss 1 on 2014-05-17.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

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
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.mapType = MKMapTypeStandard;
	
	CLLocationCoordinate2D coord = {.latitude =  self->latitude, .longitude =  self->longitude};
	MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
	MKCoordinateRegion region = {coord, span};

	[mapView setRegion:region];
	[self.view addSubview:mapView];
	MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = self->title;
    point.subtitle = self->location;
    
    [self->mapView addAnnotation:point];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
