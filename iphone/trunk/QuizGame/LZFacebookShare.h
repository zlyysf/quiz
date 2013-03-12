//
//  LZFacebookShare.h
//  QuizGame
//
//  Created by liu miao on 3/12/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKFacebook.h"
#define LZShareFacebookDidSendNotification @"LZShareFacebookDidSendNotification"
#define kFacebookBonusKey @"LZFacebookBonus"
#define kFacebookBonusDelta 20
@interface LZFacebookShare : NSObject<SHKSharerDelegate>
@property (nonatomic)BOOL isSending;
+ (LZFacebookShare *)sharedInstance;
-(void)share;
@end
