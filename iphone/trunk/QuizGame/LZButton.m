//
//  LZButton.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZButton.h"
//#import "LZSoundManager.h"
@implementation LZButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lzbutton@2x" ofType:@"png"]];//[UIImage imageNamed:@"lzbutton"];
    UIImage *backImage = [image stretchableImageWithLeftCapWidth:25.0 topCapHeight:25.0];
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [[LZSoundManager SharedInstance]playButtonSound];
//    [super touchesEnded:touches withEvent:event];
//}
@end
