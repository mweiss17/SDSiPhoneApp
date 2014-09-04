
#import <UIKit/UIKit.h>
#import "cEventViewController.h"
#import "baTableViewCell.h"
#import "AppDelegate.h"
#import "Common.h"

@interface bTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
	cEventViewController *dest;
}
@property (nonatomic, retain) NSArray *eventDict;
@end

