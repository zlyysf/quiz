//
//  LZFacebookShare.m
//  QuizGame
//
//  Created by liu miao on 3/12/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFacebookShare.h"
#import "LZDataAccess.h"
@implementation LZFacebookShare
@synthesize isSending;
+ (LZFacebookShare *)sharedInstance
{
    static dispatch_once_t LZFacebookOnce;
    static LZFacebookShare * sharedInstance;
    dispatch_once(&LZFacebookOnce, ^{
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
        SHKFacebook *facebookShare = [[SHKFacebook alloc]init];
        facebookShare.item = item;
        facebookShare.shareDelegate = self;
        [facebookShare share];
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
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:kFacebookBonusKey])
//    {
//        return;
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kFacebookBonusKey];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [[LZDataAccess singleton]updateUserTotalCoinByDelta:kFacebookBonusDelta];
//        [[NSNotificationCenter defaultCenter]postNotificationName:LZShareFacebookDidSendNotification object:nil];
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
