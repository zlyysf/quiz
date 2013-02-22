//
//  PackageCell.h
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZCell.h"

@interface PackageCell : LZCell
@property (strong, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (nonatomic,strong)IBOutlet LZButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *packageTotalScoreLabel;
@property (strong, nonatomic) IBOutlet UIImageView *scoreIconImageView;
@property (strong, nonatomic) IBOutlet UILabel *packageProgressLabel;
@property (strong, nonatomic) IBOutlet UIImageView *progressIconImageView;
@property (strong, nonatomic) IBOutlet UIImageView *packageLockImageView;
-(void)setLocked:(BOOL)lock;
@end
