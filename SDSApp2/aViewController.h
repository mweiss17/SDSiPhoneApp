//
//  ViewController.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-15.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "bTableViewController.h"

@interface aViewController : UIViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>{
	UIImageView* mIntroTopImageView;
	UIImageView* mIntroBottomImageView;
	BOOL requestReturned;
}
@property (nonatomic, retain) NSArray *eventDict;
@property (strong, retain) IBOutlet UIImageView *IntroTopImageView;
@property (strong, nonatomic) IBOutlet UIButton *ChangeView;

@end
