//
//  LZStoreViewController.m
//  QuizGame
//
//  Created by liu miao on 1/31/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZStoreViewController.h"
#import "StorePurchaseCell.h"
#import "RestorePurchaseCell.h"
#import "StoreFreeCell.h"
@interface LZStoreViewController ()<LZCellDelegate>

@end

@implementation LZStoreViewController
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
    [self.view addSubview:listView];
    self.topNavView.topNavType = TopNavTypeStore;
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0)
        return 6;
    else
        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        StorePurchaseCell *cell = (StorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"StorePurchaseCell"];
        cell.productNameLabel.text = @"No Ads";
        cell.productPriceLabel.text = @"$ 0.99";
        cell.cellIndexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    else
    {
        if (indexPath.row == 3)
        {
            RestorePurchaseCell *cell = (RestorePurchaseCell *)[tableView dequeueReusableCellWithIdentifier:@"RestorePurchaseCell"];
            [cell.selectButton setTitle:@"Restore purchase" forState:UIControlStateNormal];
            cell.cellIndexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
        else
        {
            StoreFreeCell *cell = (StoreFreeCell *)[tableView dequeueReusableCellWithIdentifier:@"StoreFreeCell"];
            [cell.iconImageView setImage:[UIImage imageNamed:@"facebook.png"]];
            cell.descriptionLabel.text = @"Tell your facebook friends.";
            cell.profitLabel.text = @"Get 50 Tokens.";
            cell.cellIndexPath = indexPath;
            cell.delegate = self;
            return cell;
            
        }
    }
    
}
#pragma -mark  LZCell Delegate
-(void)selectedLZCell:(NSIndexPath *)LZCellIndexPath
{
    NSLog(@"select store cell section %d  row %d",LZCellIndexPath.section,LZCellIndexPath.row);
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
