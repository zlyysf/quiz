//
//  LZPackageViewController.m
//  QuizGame
//
//  Created by liu miao on 1/30/13.
//  Copyright (c) 2013 lingzhi mobile. All rights reserved.
//

#import "LZPackageViewController.h"
#import "PackageCell.h"
@interface LZPackageViewController ()

@end

@implementation LZPackageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PackageCell *cell = (PackageCell *)[tableView dequeueReusableCellWithIdentifier:@"PackageCell"];
    [cell.selectButton setTitle:[NSString stringWithFormat:@"package %d",indexPath.row+1] forState:UIControlStateNormal];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topNavView.topNavType = TopNavTypeNormal;
    [self.view addSubview:self.listView];
	// Do any additional setup after loading the view.
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
