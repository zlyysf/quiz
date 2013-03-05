//
//  LZSoundManager.h
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h> 
@interface LZSoundManager : NSObject<AVAudioPlayerDelegate>
{
    SystemSoundID buttonSound;
    SystemSoundID correctSound;
    SystemSoundID wrongSound;
    AVAudioPlayer *audioPlayer;
}
+(LZSoundManager*)SharedInstance;
-(void)playButtonSound;
-(void)playCorrectSound;
-(void)playWrongSound;
-(void)playBackGroundMusic;
@end
