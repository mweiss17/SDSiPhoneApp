//
//  SDSViewController.m
//  SDS
//
//  Created by Genevieve L'Esperance on 2014-04-17.
//  Copyright (c) 2014 Silent Disco Squad. All rights reserved.
//

#import "SDSViewController.h"

@interface SDSViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Enter;

@end

@implementation SDSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choseJoinTheSquad:(id)sender
{

    [self performSegueWithIdentifier:@"ToTabBarController" sender:nil];
    [sender setEnabled:false];
}

@end
