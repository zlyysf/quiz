//
//  LZFactoryViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"

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
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    self.controllerBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    [self.controllerBackImageView setImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:controllerBackImageView];
    self.topNavView = [[LZTopNavView alloc]initWithFrame:kTopNavViewFrame delegate:self];
    [self.view addSubview:topNavView];
	// Do any additional setup after loading the view.
}
- (void)resizeContentViewFrame:(UIView *)contentView
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"])
    {
        
        contentView.frame = CGRectMake(0,kTopNavViewFrame.size.height , screenSize.width, screenSize.height-[[UIApplication sharedApplication]statusBarFrame].size.height-kTopNavViewFrame.size.height);
    }
    else
    {
        contentView.frame = CGRectMake(0,kTopNavViewFrame.size.height , screenSize.width, screenSize.height-[[UIApplication sharedApplication]statusBarFrame].size.height-kTopNavViewFrame.size.height-GAD_SIZE_320x50.height);
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"LZAdsOff"])
    {
         GADMasterViewController *shared = [GADMasterViewController singleton];
        [shared removeAds];
    }
    else
    {
        GADMasterViewController *shared = [GADMasterViewController singleton];
        [shared resetAdView:self];
    }
    NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
    NSLog(@"%@",userInfo);
    int userGold = [[userInfo objectForKey:@"totalCoin"] integerValue];
    self.topNavView.goldCountLabel.text = [NSString stringWithFormat:@"%d",userGold];
    
}
- (void)refreshGold
{
    NSDictionary *userInfo = [[LZDataAccess singleton]getUserTotalScore];
    NSLog(@"%@",userInfo);
    int userGold = [[userInfo objectForKey:@"totalCoin"] integerValue];
    self.topNavView.goldCountLabel.text = [NSString stringWithFormat:@"%d",userGold];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark TopNavViewDelegate
- (void)backButtonTapped{
    [self.navigationController popViewControllerAnimated:NO];
    NSLog(@"backButtonTapped");
}
- (void)goldButtonTapped{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LZStoreViewController * storeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LZStoreViewController"];
    [self.navigationController pushViewController:storeViewController animated:NO];
   NSLog(@"goldButtonTapped");
}
@end
