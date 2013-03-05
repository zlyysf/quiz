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
@end
