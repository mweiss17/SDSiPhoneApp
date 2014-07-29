//
//  ViewController.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-07-15.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface aViewController : UIViewController{
	UIImageView* mIntroTopImageView;
	UIImageView* mIntroBottomImageView;
	
}

@property (strong, retain) IBOutlet UIImageView *IntroTopImageView;
@property (strong, retain) IBOutlet UIImageView *IntroBottomImageView;
@property (strong, nonatomic) IBOutlet UIButton *ChangeView;

@end
