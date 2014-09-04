//
//  dMusicTableViewController.h
//  SDSApp2
//
//  Created by Martin Weiss 1 on 2014-08-05.
//  Copyright (c) 2014 Martin Weiss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@protocol PassInformation <NSObject>
-(void) setTrack:(MPMediaItem*)song;
@end

@interface dMusicTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
	MPMediaItem *song;
}
@property (nonatomic, unsafe_unretained) id<PassInformation> delegate;
@end
