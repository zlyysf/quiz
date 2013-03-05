//
//  LZAppDelegate.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZAppDelegate.h"
#import "LZDataAccess+GenSql.h"
#import "LZSHKConfigurator.h"
#import "LZIAPManager.h"
#import "LZTapjoyHelper.h"
#import "LZSoundManager.h"
@implementation LZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LZAdsOff"];
    //[[NSUserDefaults standardUserDefaults]synchronize];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *appKey = [NSString stringWithFormat:@"%@%@",appName,appVersion];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:appKey]) {
        [[LZDataAccess singleton]cleanDb];
        [[LZDataAccess singleton]initDbWithGeneratedSql];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:appKey];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LZSoundOn"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    DefaultSHKConfigurator *configurator = [[LZSHKConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    [LZIAPManager sharedInstance];
    
    [[LZTapjoyHelper singleton] connectTapjoy];
    [[LZTapjoyHelper singleton] getFullScreenAd];
    
    [[LZSoundManager SharedInstance] playBackGroundMusic];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [SHKFacebook handleWillTerminate];
}
- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}

@end
