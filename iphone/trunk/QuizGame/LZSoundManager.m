//
//  LZSoundManager.m
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSoundManager.h"

@implementation LZSoundManager
+(LZSoundManager*)SharedInstance
{
    static dispatch_once_t LZSMOnce;
    static LZSoundManager * sharedInstance;
    dispatch_once(&LZSMOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}
-(id)init
{
    if ( self = [super init])
    {
        NSString *button = [[NSBundle mainBundle] pathForResource:@"button" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:button],&buttonSound);
        NSString *correct = [[NSBundle mainBundle] pathForResource:@"correct" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:correct],&correctSound);
        NSString *wrong = [[NSBundle mainBundle] pathForResource:@"wrong" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:wrong],&wrongSound);
        NSString *musicPath = [[NSBundle mainBundle]  pathForResource:@"Wallpaper"   ofType:@"mp3"];
        
        if (musicPath) {
            
            NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
            
            audioPlayer = [[AVAudioPlayer alloc]  initWithContentsOfURL:musicURL  error:nil];
            [audioPlayer prepareToPlay];
            [audioPlayer setDelegate:self];
            audioPlayer.numberOfLoops = -1;
        }
    }
    return  self;
}
-(void)playButtonSound
{
    AudioServicesPlaySystemSound(buttonSound);
}
-(void)playCorrectSound
{
    AudioServicesPlaySystemSound(correctSound);
}
-(void)playWrongSound
{
    AudioServicesPlaySystemSound(wrongSound);
}
-(void)playBackGroundMusic
{
    [audioPlayer play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player   successfully:(BOOL)flag
{
    //[audioButton setTitle:@"Play Audio File"   forState:UIControlStateNormal];
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    [audioPlayer play];
}
@end
