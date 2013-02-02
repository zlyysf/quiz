//
//  GADMasterViewController.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "GADMasterViewController.h"
#define MY_BANNER_UNIT_ID @"a14fb773a49c5c9"//a14f0800ac9dfad。a14fb76d4362e2a
//这里写你的id    admob上注册应用后获取自己的id
@interface GADMasterViewController ()<GADBannerViewDelegate>

@end

@implementation GADMasterViewController

+(GADMasterViewController *)singleton {
    static dispatch_once_t pred;
    static GADMasterViewController *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[GADMasterViewController alloc] init];
    });
    return shared;
}
-(id)init {
    if (self = [super init]) {
        CGSize screenSize = [[UIScreen mainScreen]bounds].size;
        adBanner_ = [[GADBannerView alloc]
                     initWithFrame:CGRectMake(0.0,
                                              screenSize.height - GAD_SIZE_320x50.height,
                                              GAD_SIZE_320x50.width,
                                              GAD_SIZE_320x50.height)];
        NSLog(@"admob view width %f ,height %f",adBanner_.frame.size.width,adBanner_.frame.size.height);
        // Has an ad request already been made
        isLoaded_ = NO;
    }
    return self;
}

-(void)resetAdView:(UIViewController *)rootViewController {
    // Always keep track of currentDelegate for notification forwarding
    currentDelegate_ = rootViewController;
    // Ad already requested, simply add it into the view
    if (isLoaded_) {
        [rootViewController.view addSubview:adBanner_];

    } else {
        
        adBanner_.delegate = self;
        adBanner_.rootViewController = rootViewController;
        adBanner_.adUnitID = MY_BANNER_UNIT_ID;
        
        GADRequest *request = [GADRequest request];
        [adBanner_ loadRequest:request];
        [rootViewController.view addSubview:adBanner_];
        isLoaded_ = YES;
    }
}
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    if (adBanner_.hasAutoRefreshed)
    {
        NSLog(@"hasAutoRefreshed YES");
    }
    else
    {
        NSLog(@"hasAutoRefreshed NO");
    }
    if ([currentDelegate_ respondsToSelector:@selector(adViewDidReceiveAd:)]) {
        [currentDelegate_ adViewDidReceiveAd:view];
    }
}
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Admob Error %@",[error description]);
    if (adBanner_.hasAutoRefreshed)
    {
        NSLog(@"hasAutoRefreshed YES");
    }
    else
    {
        NSLog(@"hasAutoRefreshed NO");
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
