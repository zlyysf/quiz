//
//  LZTwitterShare.h
//  QuizGame
//
//  Created by liu miao on 3/12/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHKTwitter.h"
#define LZShareTwitterDidSendNotification @"LZShareTwitterDidSendNotification"
#define kTwitterBonusKey @"LZTwitterBonus"
#define kTwitterBonusDelta 20
@interface LZTwitterShare : NSObject<SHKSharerDelegate>
@property (nonatomic)BOOL isSending;
+ (LZTwitterShare *)sharedInstance;
-(void)share;
@end
