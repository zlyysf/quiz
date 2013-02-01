//
//  PackageCell.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "PackageCell.h"

@implementation PackageCell
@synthesize selectButton;
@synthesize packageNameLabel;
@synthesize packageTotalSubjectCountLabel;
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

- (IBAction)buttonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLZCell:) ])
    {
        [self.delegate selectedLZCell:self.cellIndexPath];
    }
}

@end
