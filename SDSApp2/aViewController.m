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
	
	timer = [NSTimer scheduledTimerWithTimeInterval:2.0
									 target:self
								   selector:@selector(nextAction)
								   userInfo:nil
									repeats:YES];
	
	
}

-(void)nextAction
{
	[timer invalidate];
	[_ChangeView sendActionsForControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
