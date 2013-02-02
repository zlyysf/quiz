//
//  LZGamingViewController.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZGamingViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LZGamingViewController ()<LZPlayViewDelegate>

@end

@implementation LZGamingViewController
@synthesize playView1;
@synthesize playView2;
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
    self.topNavView.topNavType = TopNavTypeGaming;
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGRect playFrame = CGRectMake(0, self.topNavView.frame.origin.y+self.topNavView.frame.size.height, screenSize.width, screenSize.height-self.topNavView.frame.size.height-50);
    playView1 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView1.progressLabel.text = @"1/10";
    playView1.delegate = self;
    [self.view addSubview:playView1];
    
    playView2 = [[LZPlayView alloc]initWithFrame:playFrame];
    playView2.delegate = self;
    playView2.progressLabel.text = @"2/10";
    //[self.view addSubview:playView2];
	// Do any additional setup after loading the view.
}
#pragma -mark LZPlay View Delegate
- (void)playViewButtonClicked:(UIButton*)button
{
    NSString *message = [NSString stringWithFormat:@"tapped button tag %d",button.tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    //[[GADMasterViewController singleton] removeAds];
    if (playView1.superview)
    {
        [playView1 removeFromSuperview];
        [self.view addSubview:playView2];
    }
    else
    {
        [playView2 removeFromSuperview];
        [self.view addSubview:playView1];
    }
    [UIView commitAnimations];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
