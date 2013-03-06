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
    BOOL _gameCenterFeaturesEnabled;
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

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error)
     {
     [self setLastError:error];
         if ([GKLocalPlayer localPlayer].authenticated)
         {
            _gameCenterFeaturesEnabled = YES;
         }
         else
         {
             _gameCenterFeaturesEnabled = NO;
         }

     }];
         
//     }] =
//    ^(UIViewController *viewController,
//      NSError *error) {
//        
//        [self setLastError:error];
//        if ([GKLocalPlayer localPlayer].authenticated) {
//            _gameCenterFeaturesEnabled = YES;
//        } else if(viewController) {
//            [self presentViewController:viewController];
//        } else {
//            _gameCenterFeaturesEnabled = NO;
//        }
//    };
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
    if (!_gameCenterFeaturesEnabled) {
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
         if (success) {
             GKLeaderboardViewController *gkcontroller = [[GKLeaderboardViewController alloc]init];
             gkcontroller.category = kHighScoreLeaderboardCategory;
             gkcontroller.timeScope = GKLeaderboardTimeScopeToday;
             gkcontroller.leaderboardDelegate = self;
             [self presentViewController:gkcontroller];
         }
     
     }];
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [viewController dismissModalViewControllerAnimated:YES];
}
@end
