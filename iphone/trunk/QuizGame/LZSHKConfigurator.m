//
//  LZSHKConfigurator.m
//  QuizGame
//
//  Created by liu miao on 2/20/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSHKConfigurator.h"

@implementation LZSHKConfigurator

/*
 App Description
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	return @"QuizAwesome";
}

- (NSString*)appURL {
	return @"http://itunes.com/apps/QuizAwesome";
}
- (NSString*)facebookAppId {
	return @"145015595660349";
}
- (NSString*)twitterConsumerKey {
	return @"J8tJZekG3zWgvqxeR9Q";
}

- (NSString*)twitterSecret {
	return @"sPW5hCTSujGTraV085PB8aB1rLQotRry59nDS77dJIs";
}
// SHKActionSheet settings
- (NSNumber*)showActionSheetMoreButton {
	return [NSNumber numberWithBool:NO];// Setting this to true will show More... button in SHKActionSheet, setting to false will leave the button out.
}
- (NSArray*)defaultFavoriteImageSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", nil];
}
- (NSArray*)defaultFavoriteTextSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", nil];
}
- (NSNumber*)autoOrderFavoriteSharers {
    return [NSNumber numberWithBool:false];
}
@end
