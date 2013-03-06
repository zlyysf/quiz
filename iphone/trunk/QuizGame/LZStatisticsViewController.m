//
//  LZStatisticsViewController.m
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZStatisticsViewController.h"
#import "GameKitHelper.h"
@interface LZStatisticsViewController ()<GameKitHelperProtocol>

@end

@implementation LZStatisticsViewController

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
    [self.view bringSubviewToFront:self.gameCenterButton];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"LZStatisticsViewController");
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    [self refreshGold];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gameCenterButtonClicked {
    NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
    NSLog(@"%@",userInfo);
    int userGold = [[userInfo objectForKey:@"totalScore"] integerValue];
    [[GameKitHelper sharedGameKitHelper]
     submitScore:(int64_t)userGold
     category:kHighScoreLeaderboardCategory];
}
- (void)viewDidUnload {
    [self setGameCenterButton:nil];
    [super viewDidUnload];
}
@end
