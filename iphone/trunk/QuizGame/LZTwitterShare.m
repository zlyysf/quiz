//
//  LZTwitterShare.m
//  QuizGame
//
//  Created by liu miao on 3/12/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTwitterShare.h"
#import "LZDataAccess.h"
@implementation LZTwitterShare
@synthesize isSending;
+ (LZTwitterShare *)sharedInstance
{
    static dispatch_once_t LZTwitterOnce;
    static LZTwitterShare * sharedInstance;
    dispatch_once(&LZTwitterOnce, ^{
        sharedInstance = [[self alloc]init];
    });
    return  sharedInstance;
    
}
-(void)share
{
    if(!isSending)
    {
        NSURL *ourAppUrl = [ [ NSURL alloc ] initWithString: @"https://itunes.apple.com/app/id611092526" ];
        SHKItem *item = [SHKItem URL:ourAppUrl title:NSLocalizedString(@"Come to join Quiz Awesome and have fun", @"") contentType:SHKURLContentTypeUndefined];
        SHKTwitter *twitterShare = [[SHKTwitter alloc]init];
        twitterShare.item = item;
        twitterShare.shareDelegate = self;
        [twitterShare share];
    }
    
}
#pragma mark- SHKSharerDelegate

- (void)sharerStartedSending:(SHKSharer *)sharer
{
    isSending = YES;
}
- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    isSending = NO;
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:kTwitterBonusKey])
//    {
//        return;
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kTwitterBonusKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [[LZDataAccess singleton]updateUserTotalCoinByDelta:kTwitterBonusDelta];
//        [[NSNotificationCenter defaultCenter]postNotificationName:LZShareTwitterDidSendNotification object:nil];
//    }
}
- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    isSending = NO;
}
- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    isSending = NO;
}
- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    isSending = NO;
}
- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    isSending = NO;
}

@end
