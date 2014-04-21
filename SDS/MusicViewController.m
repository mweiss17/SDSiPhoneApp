//
//  MusicViewController.m
//  SDS
//
//  Created by Martin Weiss 1 on 2014-04-20.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()
@property (strong, nonatomic) NSMutableArray *songsList;
@property (strong, nonatomic) AVPlayer *audioPlayer;

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//When the Play / Pause button is pressed by the user, the audioPlayer is notified and is made to start or stop.
- (IBAction)togglePlayPauseTapped:(id)sender {
	if(self.togglePlayPause.selected) {
		[self.audioPlayer pause];
		[self.togglePlayPause setSelected:NO];
	} else {
		[self.audioPlayer play];
		[self.togglePlayPause setSelected:YES];
	}
	UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!" message:@"This is your first UIAlertview message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
    [message show];

}
- (IBAction)showMessage:(id)sender {
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
