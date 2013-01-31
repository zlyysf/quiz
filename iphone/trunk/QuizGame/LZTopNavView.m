//
//  LZTopNavView.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTopNavView.h"
#define kTopBackButtonWidth 40
#define kTopBackButtonHeight 40
@implementation LZTopNavView
@synthesize delegate;
@synthesize backgroundImageView;
@synthesize backButton;
@synthesize goldButton;
@synthesize goldCountLabel;
@synthesize correctCountLabel;
@synthesize correctIconImageView;
@synthesize wrongCountLabel;
@synthesize wrongIconImageView;
@synthesize topNavType =_topNavType;
- (id)initWithFrame:(CGRect)frame
           delegate:(id<LZTopNavViewDelegate>)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = target;
        // Initialization code
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.backgroundImageView];
        self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0 , 2 , kTopBackButtonWidth, kTopBackButtonHeight)];
        [self.backButton setImage:[UIImage imageNamed:@"top_back_button.png"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        self.goldButton = [[UIButton alloc]initWithFrame:CGRectMake(50 , 2 , kTopBackButtonWidth, kTopBackButtonHeight)];
        [self.goldButton setImage:[UIImage imageNamed:@"top_back_button.png"] forState:UIControlStateNormal];
        [self.goldButton addTarget:self action:@selector(goldButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.goldButton];
        
    }
    return self;
}
-(void)backButtonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(backButtonTapped)])
    {
        [self.delegate backButtonTapped];
    }
}
-(void)goldButtonClicked
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(goldButtonTapped)])
    {
        [self.delegate goldButtonTapped];
    }
}
-(void)setTopNavType:(TopNavType )topNavType
{
    if (topNavType == TopNavTypeNormal)
    {
        self.correctIconImageView.hidden = YES;
        self.correctCountLabel.hidden = YES;
        self.wrongIconImageView.hidden = YES;
        self.wrongCountLabel.hidden = YES;
        self.goldButton.userInteractionEnabled = YES;
    }
    else if (topNavType == TopNavTypeGaming)
    {
        self.correctIconImageView.hidden = NO;
        self.correctCountLabel.hidden = NO;
        self.wrongIconImageView.hidden = NO;
        self.wrongCountLabel.hidden = NO;
        self.goldButton.userInteractionEnabled = YES;
    }
    else
    {
        self.correctIconImageView.hidden = YES;
        self.correctCountLabel.hidden = YES;
        self.wrongIconImageView.hidden = YES;
        self.wrongCountLabel.hidden = YES;
        self.goldButton.userInteractionEnabled = NO;
    }
    _topNavType = topNavType;
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
