//
//  LZSoundManager.m
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSoundManager.h"
#define kLZSoundStatus @"LZSoundOn"
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
    if([[NSUserDefaults standardUserDefaults]boolForKey:kLZSoundStatus])
    AudioServicesPlaySystemSound(buttonSound);
}
-(void)playCorrectSound
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:kLZSoundStatus])
    AudioServicesPlaySystemSound(correctSound);
}
-(void)playWrongSound
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:kLZSoundStatus])
    AudioServicesPlaySystemSound(wrongSound);
}
-(void)playBackGroundMusic
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:kLZSoundStatus])
    [audioPlayer play];
}
-(BOOL)isSoundOn
{
   return [[NSUserDefaults standardUserDefaults]boolForKey:kLZSoundStatus];
}
-(void)setSoundOn:(BOOL)isOn
{
    if (isOn) {
        [audioPlayer play];
    }
    else
    {
        [audioPlayer pause];
    }
    [[NSUserDefaults standardUserDefaults]setBool:isOn forKey:kLZSoundStatus];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //[audioButton setTitle:@"Play Audio File"   forState:UIControlStateNormal];
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    [audioPlayer play];
}
@end
