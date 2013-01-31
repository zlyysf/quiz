//
//  SeguePop.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "SeguePop.h"

@implementation SeguePop
-(void)perform{
    UIViewController *source = (UIViewController*)self.sourceViewController;
    [source.navigationController popViewControllerAnimated:NO];
}
@end
