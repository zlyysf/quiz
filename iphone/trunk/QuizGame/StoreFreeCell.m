//
//  StoreFreeCell.m
//  QuizGame
//
//  Created by liu miao on 2/1/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "StoreFreeCell.h"

@implementation StoreFreeCell
@synthesize selectButton;
@synthesize iconImageView;
@synthesize descriptionLabel;
@synthesize profitLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)selectButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLZCell:)])
    {
        [self.delegate selectedLZCell:self.cellIndexPath];
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
