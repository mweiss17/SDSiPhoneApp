//
//  ViewController.m
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-15.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "aViewController.h"
#import "Common.h"
@interface aViewController ()
@end

@implementation aViewController
NSTimer *timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	//preset
	self->requestReturned = FALSE;
	
	//make asynchronous request for event info
	[self GetIndex];

	[self generateGraphics];
}


-(void) GetIndex
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
	
    NSURL * url = [NSURL URLWithString:@"http://silentdiscosquad.com/appindex.html/"];
	
    NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithURL:url
														completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
															if(error == nil)
															{
																self.eventDict = [NSJSONSerialization JSONObjectWithData:data
																												 options:kNilOptions
																												   error:&error];
																for(NSDictionary *item in _eventDict) {
																	NSLog (@"nsdic = %@", item);
																}
																
															}
															[self nextAction];
														}];
    [dataTask resume];
}

- (void)generateGraphics{
	self.IntroTopImageView.contentMode = UIViewContentModeCenter;
	self.IntroTopImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight);
	self.IntroTopImageView.backgroundColor = [UIColor whiteColor];
	UIImage* image1 = [UIImage imageNamed:@"LaunchIcon"];
	self.IntroTopImageView.image = image1;
}
//switch to next screen upon loading
-(void)nextAction
{
	[_ChangeView sendActionsForControlEvents:UIControlEventTouchUpInside];
}

//pass the info to the next screen
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	bTableViewController *nextViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
	nextViewController.eventDict = [self eventDict];//the array you want to pass
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
