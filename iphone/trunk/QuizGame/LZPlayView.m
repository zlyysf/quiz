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
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        progressLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 10,200, 26)];
        [progressLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:25.f]];
        [progressLabel setTextColor:[UIColor grayColor]];
        progressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:progressLabel];
        
        questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressLabel.frame.origin.x, progressLabel.frame.origin.y+progressLabel.frame.size.height + 5, 250, 40)];
        [questionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:33]];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.textColor = [UIColor whiteColor];
        questionLabel.numberOfLines = 0;
        [self addSubview:questionLabel];
        
        winButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-40,  10, 20, 30)];
        winButton.tag = kWinButtonTag;
        UIImage *winImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"win_question@2x" ofType:@"png"]];
        [winButton setBackgroundImage:winImg forState:UIControlStateNormal];
        [winButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:winButton];
        
        cutWrongButton = [[UIButton alloc]initWithFrame:CGRectMake(winButton.frame.origin.x, winButton.frame.origin.y + winButton.frame.size.height +10, 22, 29)];
        cutWrongButton.tag = kCutWrongButtonTag;
        UIImage *wrongImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cut_wrong@2x" ofType:@"png"]];
        [cutWrongButton setBackgroundImage:wrongImg forState:UIControlStateNormal];
        [cutWrongButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cutWrongButton];
        
        askFriendsButton = [[UIButton alloc]initWithFrame:CGRectMake(cutWrongButton.frame.origin.x, cutWrongButton.frame.origin.y + cutWrongButton.frame.size.height +10, 22, 29)];
        askFriendsButton.tag = kAskFriendsButtonTag;
        [askFriendsButton setBackgroundImage:[UIImage imageNamed:@"ask_friends.png"] forState:UIControlStateNormal];
        [askFriendsButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:askFriendsButton];
        
        answerDownLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, frame.size.height-10-kAnswerButtonSideLength, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        //[answerDownLeftButton setBackgroundImage:[UIImage imageNamed:@"icon_1.jpg" ] forState:UIControlStateNormal];
        [answerDownLeftButton.layer setMasksToBounds:YES];
        [answerDownLeftButton.layer setCornerRadius:10.0];
        [answerDownLeftButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        answerDownLeftButton.tag = kAnswerDownLeftButtonTag;
        [self addSubview:answerDownLeftButton];
        
        answerDownRightButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownLeftButton.frame.origin.x +10 + kAnswerButtonSideLength, answerDownLeftButton.frame.origin.y, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        //[answerDownRightButton setBackgroundImage:[UIImage imageNamed:@"icon_2.jpg" ] forState:UIControlStateNormal];
        [answerDownRightButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        answerDownRightButton.tag = kAnswerDownRightButtonTag;
        [answerDownRightButton.layer setMasksToBounds:YES];
        [answerDownRightButton.layer setCornerRadius:10.0];
        [self addSubview:answerDownRightButton];
        
        answerUpLeftButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownLeftButton.frame.origin.x, answerDownLeftButton.frame.origin.y-10-kAnswerButtonSideLength, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        //[answerUpLeftButton setBackgroundImage:[UIImage imageNamed:@"icon_3.jpg" ] forState:UIControlStateNormal];
        [answerUpLeftButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        answerUpLeftButton.tag = kAnswerUpLeftButtonTag;
        [answerUpLeftButton.layer setMasksToBounds:YES];
        [answerUpLeftButton.layer setCornerRadius:10.0];
        [self addSubview:answerUpLeftButton];
        
        answerUpRightButton = [[UIButton alloc]initWithFrame:CGRectMake(answerDownRightButton.frame.origin.x, answerUpLeftButton.frame.origin.y, kAnswerButtonSideLength, kAnswerButtonSideLength)];
        //[answerUpRightButton setBackgroundImage:[UIImage imageNamed:@"icon_4.jpg" ] forState:UIControlStateNormal];
        [answerUpRightButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        answerUpRightButton.tag = kAnswerUpRightButtonTag;
        [answerUpRightButton.layer setMasksToBounds:YES];
        [answerUpRightButton.layer setCornerRadius:10.0];
        [self addSubview:answerUpRightButton];
        
    }
    return self;
}
-(void)buttonTapped:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playViewButtonClicked:)])
    {
        [self.delegate playViewButtonClicked:sender];
    }
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
