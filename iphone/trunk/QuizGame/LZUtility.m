//
//  LZUtility.m
//  QuizGame
//
//  Created by liu miao on 3/20/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZUtility.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
@implementation LZUtility
//+(BOOL)isTwitterAvailable {
//    return NSClassFromString(@"TWTweetComposeViewController") != nil;
//}

+(BOOL)isSocialAvailable {
    return NSClassFromString(@"SLComposeViewController") != nil;
}
+(BOOL)isFacebookAvailable
{
    if ([[self class]isSocialAvailable])//6.0+
    {
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if (facebook)
            return YES;
        else
            return NO;
    }
    else//5.0+
    {
        return YES;
    }
}
+(BOOL)isTwitterAvailable
{
    if ([[self class]isSocialAvailable])//6.0+
    {
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (facebook)
            return YES;
        else
            return NO;

    }
    else//5.0+
    {
        if ([TWTweetComposeViewController canSendTweet])
            return YES;
        else
            return NO;
    }

}
@end
