//
//  MissionViewController.h
//  SDS
//
//  Created by Martin Weiss 1 on 2014-04-28.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventViewController.h"
@interface MissionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate>{
	EventViewController *dest;
}
@property (strong, nonatomic) IBOutlet UITableView *EventTable;
@end
