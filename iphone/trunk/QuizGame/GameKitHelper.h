//
//  GameKitHelper.h
//  QuizGame
//
//  Created by liu miao on 3/6/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <GameKit/GameKit.h>
#define kHighScoreLeaderboardCategory @"com.lingzhi.QuizAwsome.HighScores"
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end


@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;
-(void) submitScore:(int64_t)score
           category:(NSString*)category;
-(void)showLeaderboardAndSubmitScore:(int64_t)score
                            category:(NSString*)category;
@end
