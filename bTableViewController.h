//
//  bTableViewController.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-23.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cEventViewController.h"
#import "baTableViewCell.h"
#import "AppDelegate.h"
#import "Common.h"

@interface bTableViewController : UITableViewController<NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource>{
	cEventViewController *dest;
}
@property (nonatomic, retain) NSArray *eventDict;
@property (nonatomic, retain) MKUserLocation *userLocation;
@end

