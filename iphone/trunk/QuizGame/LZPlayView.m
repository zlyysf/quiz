//
//  LZPlayView.m
//  QuizGame
//
//  Created by liu miao on 2/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZPlayView.h"
#import <QuartzCore/QuartzCore.h>
@implementation LZPlayView
@synthesize progressLabel;
@synthesize questionLabel;
@synthesize winButton;
@synthesize cutWrongButton;
@synthesize askFriendsButton;
@synthesize answerUpLeftButton;
@synthesize answerUpRightButton;
@synthesize answerDownLeftButton;
@synthesize answerDownRightButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        progressLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 10,200 , 40)];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.text = @"5/10";
        [self addSubview:progressLabel];
        
        questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y+progressLabel.frame.size.height + 10, 200, 40)];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.textColor = [UIColor whiteColor];
        questionLabel.text = @"LOUIS LU?DY";
        [self addSubview:questionLabel];
        
        winButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-40,  10, kHelpButtonSideLength, kHelpButtonSideLength)];
        winButton.tag = kWinButtonTag;
        [winButton setImage:[UIImage imageNamed:@"win_question.png"] forState:UIControlStateNormal];
        [self addSubview:winButton];
        
        cutWrongButton = [[UIButton alloc]initWithFrame:CGRectMake(winButton.frame.origin.x, winButton.frame.origin.y + winButton.frame.size.height +10, kHelpButtonSideLength, kHelpButtonSideLength)];
        cutWrongButton.tag = kCutWrongButtonTag;
        [cutWrongButton setImage:[UIImage imageNamed:@"cut_wrong.png"] forState:UIControlStateNormal];
        [self addSubview:cutWrongButton];
        
        askFriendsButton = [[UIButton alloc]initWithFrame:CGRectMake(cutWrongButton.frame.origin.x, cutWrongButton.frame.origin.y + cutWrongButton.frame.size.height +10, kHelpButtonSideLength, kHelpButtonSideLength)];
        askFriendsButton.tag = kAskFriendsButtonTag;
        [askFriendsButton setImage:[UIImage imageNamed:@"ask_friends.png"] forState:UIControlStateNormal];
        [self addSubview:askFriendsButton];
        
        answerDownLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height-10-kAnswerButtonSideLength, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        [answerDownLeftButton setBackgroundImage:[UIImage imageNamed:@"icon_1.jpg" ] forState:UIControlStateNormal];
        [answerDownLeftButton.layer setMasksToBounds:YES];
        [answerDownLeftButton.layer setCornerRadius:10.0];
        answerDownLeftButton.tag = kAnswerDownLeftButtonTag;
        [self addSubview:answerDownLeftButton];
        
        answerDownRightButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownLeftButton.frame.origin.x +10 + kAnswerButtonSideLength, answerDownLeftButton.frame.origin.y, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        [answerDownRightButton setBackgroundImage:[UIImage imageNamed:@"icon_2.jpg" ] forState:UIControlStateNormal];
        answerDownRightButton.tag = kAnswerDownRightButtonTag;
        [answerDownRightButton.layer setMasksToBounds:YES];
        [answerDownRightButton.layer setCornerRadius:10.0];
        [self addSubview:answerDownRightButton];
        
        answerUpLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownLeftButton.frame.origin.x, answerDownLeftButton.frame.origin.y-10-kAnswerButtonSideLength, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        [answerUpLeftButton setBackgroundImage:[UIImage imageNamed:@"icon_3.jpg" ] forState:UIControlStateNormal];
        answerUpLeftButton.tag = kAnswerUpLeftButtonTag;
        [answerUpLeftButton.layer setMasksToBounds:YES];
        [answerUpLeftButton.layer setCornerRadius:10.0];
        [self addSubview:answerUpLeftButton];
        
        answerUpRightButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownRightButton.frame.origin.x, answerUpLeftButton.frame.origin.y, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        [answerUpRightButton setBackgroundImage:[UIImage imageNamed:@"icon_4.jpg" ] forState:UIControlStateNormal];
        answerUpRightButton.tag = kAnswerUpRightButtonTag;
        [answerUpRightButton.layer setMasksToBounds:YES];
        [answerUpRightButton.layer setCornerRadius:10.0];
        [self addSubview:answerUpRightButton];
        
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

@end
