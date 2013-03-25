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
	return @"Quiz Awesome";
}

- (NSString*)appURL {
	return @"https://itunes.apple.com/app/id611092526";
}
- (NSString*)facebookAppId {
	return @"127942747390943";
}
- (NSString*)twitterConsumerKey {
	return @"cDVQUOWBuer2z07HK7mwPQ";
}

- (NSString*)twitterSecret {
	return @"lBPRz0Vgj3rDmqV6lZnOwpakxBXEPWvaGrRlE3dINBI";
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
