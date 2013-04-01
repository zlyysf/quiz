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
{
    MBProgressHUD *HUD;
}
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
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appKey = [NSString stringWithFormat:@"%@%@",appName,appVersion];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:appKey])
    {
        [self.storeButton setEnabled:NO];
        [self.settingButton setEnabled:NO];
        [self.playButton setEnabled:NO];
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Loading data for first launch...", @"");
        HUD.dimBackground =YES;
        [HUD show:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad:) name:@"AppFirstDataInitialized" object:nil];
}
- (void)dataDidLoad:(NSNotification *)notification
{
    [self.storeButton setEnabled:YES];
    [self.settingButton setEnabled:YES];
    [self.playButton setEnabled:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppFirstDataInitialized" object:nil];
}
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPlayButton:nil];
    [self setStoreButton:nil];
    [self setSettingButton:nil];
    [super viewDidUnload];
}
@end
