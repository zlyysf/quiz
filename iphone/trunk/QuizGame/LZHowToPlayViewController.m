//
//  LZHowToPlayViewController.m
//  QuizGame
//
//  Created by liu miao on 3/5/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZHowToPlayViewController.h"
#define kHowToPlayContentSize CGSizeMake(320, 366*2)
@interface LZHowToPlayViewController ()

@end

@implementation LZHowToPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topNavView.topNavType = TopNavTypeNormal;
    [self.view bringSubviewToFront:self.contentScrollView];
#warning you need to set the whole contentsize below
    [self.contentScrollView setContentSize:kHowToPlayContentSize];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"LZHowToPlayViewController");
    [super viewWillAppear:animated];
    [self resizeContentViewFrame:self.contentScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    [self resizeContentViewFrame:self.contentScrollView];
    [self refreshGold];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [super viewDidUnload];
}
@end
