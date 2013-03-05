//
//  LZTopNavView.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZTopNavView.h"
#define kBackgroundImageViewFrame CGRectMake(0, 0, 320, 44)
#define kBackButtonFrame CGRectMake(20, 7, 20, 30)
#define kGoldButtonFrame CGRectMake(69, 12, 24, 22)
#define kGoldCountLabelFrame CGRectMake(98, 9, 70, 26)
#define kCorrectImageFrame CGRectMake(176, 12, 27, 20)
#define kCorrectCountLabelFrame CGRectMake(208, 9, 40, 26)
#define kWrongImageFrame CGRectMake(252, 12, 20, 20)
#define kWrongCountLabelFrame CGRectMake(277, 9, 40, 26)
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
        UIImage *topback = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"top_back_ground@2x" ofType:@"png"]];
        [self.backgroundImageView setImage:topback];
        [self addSubview:self.backgroundImageView];
        
        self.backButton = [[LZSoundButton alloc]initWithFrame:kBackButtonFrame];
        UIImage *topbackbutton = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"top_back_button@2x" ofType:@"png"]];
        [self.backButton setImage:topbackbutton forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backButton];
        
        self.goldButton = [[LZSoundButton alloc]initWithFrame:kGoldButtonFrame];
        UIImage *goldImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gold@2x" ofType:@"png"]];
        [self.goldButton setBackgroundImage:goldImg forState:UIControlStateNormal];
        [self.goldButton addTarget:self action:@selector(goldButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.goldButton];
        
        self.goldCountLabel = [[UILabel alloc]initWithFrame:kGoldCountLabelFrame];
        self.goldCountLabel.text = @"0";
        self.goldCountLabel.textColor = [UIColor whiteColor];
        self.goldCountLabel.backgroundColor = [UIColor clearColor];
        self.goldCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.f];
        [self addSubview:self.goldCountLabel];
        
        self.correctIconImageView = [[UIImageView alloc]initWithFrame:kCorrectImageFrame];
        UIImage *correctImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"correct@2x" ofType:@"png"]];
        [self.correctIconImageView setImage:correctImg];
        [self addSubview:self.correctIconImageView];
        
        self.correctCountLabel = [[UILabel alloc]initWithFrame:kCorrectCountLabelFrame];
        self.correctCountLabel.text = @"0";
        self.correctCountLabel.textColor = [UIColor whiteColor];
        self.correctCountLabel.backgroundColor = [UIColor clearColor];
        self.correctCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.f];
        [self addSubview:self.correctCountLabel];

        self.wrongIconImageView = [[UIImageView alloc]initWithFrame:kWrongImageFrame];
        UIImage *wrongImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wrong@2x" ofType:@"png"]];
        [self.wrongIconImageView setImage:wrongImg];
        [self addSubview:self.wrongIconImageView];
        
        self.wrongCountLabel = [[UILabel alloc]initWithFrame:kWrongCountLabelFrame];
        self.wrongCountLabel.text = @"0";
        self.wrongCountLabel.textColor = [UIColor whiteColor];
        self.wrongCountLabel.backgroundColor = [UIColor clearColor];
        self.wrongCountLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25.f];
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
