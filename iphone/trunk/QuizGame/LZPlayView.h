//
//  LZPlayView.h
//  QuizGame
//
//  Created by liu miao on 2/2/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZSoundButton.h"
#define kWinButtonTag 101
#define kCutWrongButtonTag 102
#define kAskFriendsButtonTag 103
#define kAnswerUpLeftButtonTag 200
#define kAnswerUpRightButtonTag 201
#define kAnswerDownLeftButtonTag 202
#define kAnswerDownRightButtonTag 203
#define kAnswerButtonSideLength 120
@protocol LZPlayViewDelegate<NSObject>
- (void)playViewButtonClicked:(UIButton*)button;
@end
@interface LZPlayView : UIView
@property (nonatomic,weak)id<LZPlayViewDelegate>delegate;
@property (nonatomic,strong)UILabel *progressLabel;
@property (nonatomic,strong)UILabel *questionLabel;
@property (nonatomic,strong)LZSoundButton *winButton;
@property (nonatomic,strong)LZSoundButton *cutWrongButton;
@property (nonatomic,strong)LZSoundButton *askFriendsButton;
@property (nonatomic,strong)UIButton *answerUpLeftButton;
@property (nonatomic,strong)UIButton *answerUpRightButton;
@property (nonatomic,strong)UIButton *answerDownLeftButton;
@property (nonatomic,strong)UIButton *answerDownRightButton;
@end
