//
//  LZViewController.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZViewController.h"
#import "GADMasterViewController.h"
@interface LZViewController ()

@end

@implementation LZViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}
- (void)viewWillAppear:(BOOL)animated
{
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
