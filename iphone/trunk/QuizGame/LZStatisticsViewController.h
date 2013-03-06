//
//  LZStatisticsViewController.h
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZFactoryViewController.h"

@interface LZStatisticsViewController : LZFactoryViewController
- (IBAction)gameCenterButtonClicked;

@property (strong, nonatomic) IBOutlet UIButton *gameCenterButton;
@end
