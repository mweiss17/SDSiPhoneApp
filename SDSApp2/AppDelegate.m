//
//  AppDelegate.m
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-15.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    // Override point for customization after application launch.
	[self GetIndex];
	return YES;

}

-(BOOL) GetIndex
{
	NSURLSession *defaultSession = [NSURLSession sharedSession];
	
    NSURL * url = [NSURL URLWithString:@"http://silentdiscosquad.com/appindex.html/"];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
														completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
															if(error == nil)
															{
																self.eventD = [NSJSONSerialization JSONObjectWithData:data
																												 options:kNilOptions
																												   error:&error];
																for(NSDictionary *item in self.eventD) {
																	NSLog (@"nsdic = %@", item);
																}
																self.returned = TRUE;
															}
														}];
    [dataTask resume];
	self.returned = FALSE;
	while(self.returned == FALSE){
		[NSThread sleepForTimeInterval:0.1f];
	}
	return TRUE;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
