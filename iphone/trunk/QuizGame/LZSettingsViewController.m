//
//  LZSettingsViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSettingsViewController.h"
@interface LZSettingsViewController ()

@end

@implementation LZSettingsViewController

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
    self.topNavView.topNavType = TopNavTypeNormal;
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma -mark TopNavViewDelegate
- (void)goldButtonTapped{
    NSLog(@"settings goldButtonTapped");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
