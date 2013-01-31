//
//  LZFactoryViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"
#import "GADMasterViewController.h"
#import "LZStoreViewController.h"
@interface LZFactoryViewController ()

@end

@implementation LZFactoryViewController
@synthesize topNavView;
@synthesize controllerBackImageView;
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
    self.controllerBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.controllerBackImageView setImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:controllerBackImageView];
    self.topNavView = [[LZTopNavView alloc]initWithFrame:kTopNavViewFrame delegate:self];
    [self.view addSubview:topNavView];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    GADMasterViewController *shared = [GADMasterViewController singleton];
    [shared resetAdView:self];
    
}
#pragma -mark TopNavViewDelegate
- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"backButtonTapped");
}
- (void)goldButtonTapped{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZStoreViewController * storeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZStoreViewController"];
    [self.navigationController pushViewController:storeViewController animated:YES];
   NSLog(@"goldButtonTapped");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
