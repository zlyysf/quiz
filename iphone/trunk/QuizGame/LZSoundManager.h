//
//  LZSoundManager.h
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface LZSoundManager : NSObject
{
    SystemSoundID buttonSound;
    SystemSoundID correctSound;
    SystemSoundID wrongSound;
}
+(LZSoundManager*)SharedInstance;
-(void)playButtonSound;
-(void)playCorrectSound;
-(void)playWrongSound;
@end
