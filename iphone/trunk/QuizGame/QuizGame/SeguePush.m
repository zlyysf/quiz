//
//  SeguePush.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "SeguePush.h"

@implementation SeguePush
-(void)perform{
    UIViewController *source = (UIViewController*)self.sourceViewController;
    UIViewController *dest = (UIViewController *)self.destinationViewController;
    [source.navigationController pushViewController:dest animated:NO];
}
@end
