//
//  LZTapjoyInterface.m
//  tryTapjoy1
//
//  Created by Yasofon on 13-3-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZTapjoyHelper.h"

@implementation LZTapjoyHelper


+(LZTapjoyHelper *)singleton{
    static dispatch_once_t pred;
    static LZTapjoyHelper *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZTapjoyHelper alloc] init];
    });
    return shared;
}

- (id)init{
    self = [super init];
    if (self) {
        existFullScreenAd = FALSE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler_tjcConnectSuccess:)
                                                     name:TJC_CONNECT_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler_tjcConnectFail:)
                                                     name:TJC_CONNECT_FAILED object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler_getFullScreenAd:)
                                                     name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler_getFullScreenAdError:)
                                                     name:TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handler_fullscreenAdClosed:)
                                                     name:TJC_VIEW_CLOSED_NOTIFICATION object:nil];
    }
    return self;
}






- (void)handler_getFullScreenAd:(NSNotification*)notifyObj
{
    NSLog(@"TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION received,\nnotifyObj=%@,\n.object=%@,\n.userInfo=%@",notifyObj,[notifyObj object],[notifyObj userInfo]);
    existFullScreenAd = TRUE;
}
- (void)handler_getFullScreenAdError:(NSNotification*)notifyObj
{
    NSLog(@"TJC_FULL_SCREEN_AD_RESPONSE_NOTIFICATION_ERROR received,\nnotifyObj=%@,\n.object=%@,\n.userInfo=%@",notifyObj,[notifyObj object],[notifyObj userInfo]);
}
-(void)handler_fullscreenAdClosed:(NSNotification*)notifyObj
{
    NSLog(@"TJC_VIEW_CLOSED_NOTIFICATION received, Fullscreen Ad closed");
}


-(void)handler_tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}
- (void)handler_tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");
}

-(void) connectTapjoy{
    //    NSString *appId = @"93e78102-cbd7-4ebf-85cc-315ba83ef2d5";
    //    NSString *appSecretKey = @"JWxgS26URM0XotaghqGn";
    
    //    NSString *appId = @"fdfcaaab-f77a-4a23-9804-adf72e7429f8";//quiz awesome
    //    NSString *appSecretKey = @"KIeOCSLkud7g1D0vz5PS";
    NSString *appId = @"7648eaad-7415-49bd-b938-bf2280b91c74";//quizNoReward
    NSString *appSecretKey = @"FkaVuDAalZh3toEgIuvo";
    //    NSString *appId = @"2e4b2dc3-4656-4855-836f-d8d4724f0a0a";//quizRewardBoth
    //    NSString *appSecretKey = @"tqWyXoK62u8vLZiYtgSg";
    [TapjoyConnect requestTapjoyConnect:appId secretKey:appSecretKey];
}

- (void)getFullScreenAd {
    //    [TapjoyConnect getFullScreenAd];
    
    NSString* currencyID = @"26aced51-b029-42b2-b4ca-3e534025afcc";//quizNoReword , Non-Rewarded ID
    [TapjoyConnect getFullScreenAdWithCurrencyID:currencyID];
    
    //    NSString* currencyID = @"ead2e7b6-1b8f-415d-ab93-f425a2d5e3db";//quizRewordBoth , Non-Rewarded ID
    //    [TapjoyConnect getFullScreenAdWithCurrencyID:currencyID];
}


- (void)showFullScreenAd {
    if (existFullScreenAd){
        //[TapjoyConnect showFullScreenAdWithViewController:self.viewController];//ok
        [TapjoyConnect showFullScreenAd];
    }else{
        [self getFullScreenAd];
    }
    
}


@end
