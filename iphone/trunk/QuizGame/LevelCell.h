//
//  LevelCell.h
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCell.h"
@interface LevelCell : LZCell
@property (strong, nonatomic) IBOutlet LZButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *levelNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *levelProgressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *levelScoreImageView;
@property (strong, nonatomic) IBOutlet UIImageView *levelProgressImageView;
@property (strong, nonatomic) IBOutlet UIImageView *levelLockImageView;
-(void)setLocked:(BOOL)lock;
@end
