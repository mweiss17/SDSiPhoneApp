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
	self.IntroBottomImageView.contentMode = UIViewContentModeCenter;
	
	self.IntroTopImageView.backgroundColor = [UIColor whiteColor];
	self.IntroBottomImageView.backgroundColor = [Common colorWithHexString:@"0e1633"];
	UIImage* image1 = [UIImage imageNamed:@"logos-03"];
	UIImage* image2 = [UIImage imageNamed:@"TurningWhite"];
	
	CGSize newSize1 = CGSizeMake(300.0f, 300.0f);
	UIGraphicsBeginImageContext(newSize1);
    [image1 drawInRect:CGRectMake(0,0,newSize1.width,newSize1.height)];
    UIImage* newImage1 = UIGraphicsGetImageFromCurrentImageContext();
	
	CGSize newSize2 = CGSizeMake(300.0f, 109.0f);
	UIGraphicsBeginImageContext(newSize2);
    [image2 drawInRect:CGRectMake(0,0,newSize2.width,newSize2.height)];
    UIImage* newImage2 = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
	self.IntroTopImageView.image = newImage1;
	self.IntroBottomImageView.image = newImage2;

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
