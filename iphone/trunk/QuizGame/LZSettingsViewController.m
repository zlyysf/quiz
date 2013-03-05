//
//  LZSettingsViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZSettingsViewController.h"
#import "SettingCell.h"
#import "LZSoundManager.h"
@interface LZSettingsViewController ()<LZCellDelegate>

@end

@implementation LZSettingsViewController
@synthesize listView;
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
    [self.view addSubview:self.listView];
    [self resizeContentViewFrame:self.listView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"normal_bg@2x" ofType:@"jpg"];
    [self.controllerBackImageView setImage:[UIImage imageWithContentsOfFile:path]];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)productPurchased:(NSNotification *)notification
{
    NSString * productIdentifier = notification.object;
    NSLog(@"purchased product %@",productIdentifier);
    /*1 user purchased remove ads
     */
    [self resizeContentViewFrame:self.listView];
    [self refreshGold];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    if (indexPath.row == 0)
    {
        if ([[LZSoundManager SharedInstance]isSoundOn])
        {
            [cell.selectButton setTitle:@"Sound On" forState:UIControlStateNormal];
        }
        else
        {
            [cell.selectButton setTitle:@"Sound Off" forState:UIControlStateNormal];
        }
    }
    else if (indexPath.row == 1)
    {
         [cell.selectButton setTitle:@"How to play" forState:UIControlStateNormal];
    }
    else
    {
        [cell.selectButton setTitle:@"Statistics" forState:UIControlStateNormal];
    }
    cell.cellIndexPath = indexPath;
    cell.delegate = self;
    return cell;
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    NSLog(@"select setting cell %d",LZCellIndexPath.row);
    if (LZCellIndexPath.row == 0)
    {
        BOOL soundStatus = [[LZSoundManager SharedInstance]isSoundOn];
        [[LZSoundManager SharedInstance]setSoundOn:!soundStatus];
        NSArray *reloadCell = [NSArray arrayWithObject:LZCellIndexPath];
        [self.listView reloadRowsAtIndexPaths:reloadCell withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (LZCellIndexPath.row == 1)
    {
        //enter how to play view
    
    }
    else
    {
        //enter statistics view
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
}
@end
