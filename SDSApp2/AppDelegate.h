//
//  AppDelegate.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-15.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate,NSURLSessionDownloadDelegate,NSURLSessionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property id completionHandler;
@property BOOL returned;
@property (nonatomic, retain) NSArray *eventD;

@end
