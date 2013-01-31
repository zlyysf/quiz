//
//  LZTopNavView.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTopNavView.h"
#define kBackgroundImageViewFrame CGRectMake(0, 0, 320, 44)
#define kBackButtonFrame CGRectMake(5, 2, 40, 40)
#define kGoldButtonFrame CGRectMake(55, 2, 40, 40)
#define kGoldCountLabelFrame CGRectMake(100, 2, 50, 40)
#define kCorrectImageFrame CGRectMake(160, 12, 20, 20)
#define kCorrectCountLabelFrame CGRectMake(205, 2, 30, 40)
#define kWrongImageFrame CGRectMake(245, 12, 20, 20)
#define kWrongCountLabelFrame CGRectMake(290, 2, 30, 40)
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
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:kBackgroundImageViewFrame];
        [self.backgroundImageView setImage:[UIImage imageNamed:@"top_back_ground.png"]];
        [self addSubview:self.backgroundImageView];
        
        self.backButton = [[UIButton alloc]initWithFrame:kBackButtonFrame];
        [self.backButton setImage:[UIImage imageNamed:@"top_back_button.png"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        
        self.goldButton = [[UIButton alloc]initWithFrame:kGoldButtonFrame];
        [self.goldButton setImage:[UIImage imageNamed:@"gold.png"] forState:UIControlStateNormal];
        [self.goldButton addTarget:self action:@selector(goldButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.goldButton];
        
        self.goldCountLabel = [[UILabel alloc]initWithFrame:kGoldCountLabelFrame];
        self.goldCountLabel.text = @"300";
        self.goldCountLabel.textColor = [UIColor whiteColor];
        self.goldCountLabel.backgroundColor = [UIColor clearColor];
        self.goldCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
        [self addSubview:self.goldCountLabel];
        
        self.correctIconImageView = [[UIImageView alloc]initWithFrame:kCorrectImageFrame];
        [self.correctIconImageView setImage:[UIImage imageNamed:@"correct.png"]];
        [self addSubview:self.correctIconImageView];
        
        self.correctCountLabel = [[UILabel alloc]initWithFrame:kCorrectCountLabelFrame];
        self.correctCountLabel.text = @"3";
        self.correctCountLabel.textColor = [UIColor whiteColor];
        self.correctCountLabel.backgroundColor = [UIColor clearColor];
        self.correctCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
        [self addSubview:self.correctCountLabel];

        self.wrongIconImageView = [[UIImageView alloc]initWithFrame:kWrongImageFrame];
        [self.wrongIconImageView setImage:[UIImage imageNamed:@"wrong.png"]];
        [self addSubview:self.wrongIconImageView];
        
        self.wrongCountLabel = [[UILabel alloc]initWithFrame:kWrongCountLabelFrame];
        self.wrongCountLabel.text = @"3";
        self.wrongCountLabel.textColor = [UIColor whiteColor];
        self.wrongCountLabel.backgroundColor = [UIColor clearColor];
        self.wrongCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
        [self addSubview:self.wrongCountLabel];

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
        self.goldButton.Enabled = YES;
    }
    else if (topNavType == TopNavTypeGaming)
    {
        self.correctIconImageView.hidden = NO;
        self.correctCountLabel.hidden = NO;
        self.wrongIconImageView.hidden = NO;
        self.wrongCountLabel.hidden = NO;
        self.goldButton.Enabled = YES;
    }
    else
    {
        self.correctIconImageView.hidden = YES;
        self.correctCountLabel.hidden = YES;
        self.wrongIconImageView.hidden = YES;
        self.wrongCountLabel.hidden = YES;
        self.goldButton.Enabled = NO;
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
