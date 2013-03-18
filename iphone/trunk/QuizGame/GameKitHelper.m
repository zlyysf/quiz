//
//  GameKitHelper.m
//  QuizGame
//
//  Created by liu miao on 3/6/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()
<GKLeaderboardViewControllerDelegate> {
}
@end

@implementation GameKitHelper
+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceGKToken;
    dispatch_once(&onceGKToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}
- (BOOL)isGameCenterEnabled
{
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];

    if(localPlayer.authenticated)
    {
        return  YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Game Center Unavailable", @"") message:NSLocalizedString(@"Please sign in the Game Center.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}
#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error)
     {
     [self setLastError:error];

     }];
}
#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}
-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (![self isGameCenterEnabled]) {
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}
-(void)showLeaderboard
{
    if (![self isGameCenterEnabled]) {
        return;
    }
    GKLeaderboardViewController *gkcontroller = [[GKLeaderboardViewController alloc]init];
    gkcontroller.category = kHighScoreLeaderboardCategory;
    gkcontroller.timeScope = GKLeaderboardTimeScopeToday;
    gkcontroller.leaderboardDelegate = self;
    [self presentViewController:gkcontroller];

}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated:YES];
}
@end
