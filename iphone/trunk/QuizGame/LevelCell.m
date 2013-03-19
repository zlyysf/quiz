//
//  LevelCell.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LevelCell.h"

@implementation LevelCell
@synthesize selectButton;
@synthesize levelNameLabel;
@synthesize levelScoreLabel;
@synthesize levelProgressLabel;
@synthesize levelScoreImageView;
@synthesize levelProgressImageView;
@synthesize levelLockImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)setLocked:(BOOL)lock
{
    if(lock)
    {
        self.levelNameLabel.hidden = NO;
        self.levelScoreLabel.hidden = YES;
        self.levelProgressLabel.hidden = YES;
        self.levelScoreImageView.hidden = YES;
        self.levelProgressImageView.hidden = YES;
        self.levelLockImageView.hidden = NO;
    }
    else
    {
        self.levelNameLabel.hidden = NO;
        self.levelScoreLabel.hidden = NO;
        self.levelProgressLabel.hidden = NO;
        self.levelScoreImageView.hidden = NO;
        self.levelProgressImageView.hidden = NO;
        self.levelLockImageView.hidden = YES;
    }
}
- (IBAction)buttonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLZCell:) ])
    {
        [self.delegate selectedLZCell:self.cellIndexPath];
    }
}

@end
