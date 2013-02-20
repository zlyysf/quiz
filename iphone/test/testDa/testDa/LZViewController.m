//
//  LZViewController.m
//  testDa
//
//  Created by Yasofon on 13-2-5.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZViewController.h"

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    da = [LZDataAccess singleton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnInit_touchUpInside:(id)sender {
    [da initDb];

    
}
- (IBAction)btnGenSql_touchUpInside:(id)sender {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle bundlePath];
    NSString *iconsPath = [bundlePath stringByAppendingPathComponent:@"quizicons"];
    
    NSString *topDirPath = iconsPath;

    [da generateInitSqlForPackages:topDirPath];
    [da generateConfigTemplateForPackages:topDirPath];
}
- (IBAction)btnSelect_touchUpInside:(id)sender {
    [da getPackages];
    
    //[da getGroupQuizzes:@"apparel t1:group 1"];
    //[da getGroupQuizOptions:@"apparel t1:group 2"];
    [da getUserTotalScore];
}

- (IBAction)btnSelGrp_touchUpInside:(id)sender {
    [da getPackageGroups:@"apparel t1"];
}



- (IBAction)btnUpdate_touchUpInside:(id)sender {
//    [da obtainQuizAward:@"apparel t1:7 For All Mankind"];
//    [da obtainQuizAward:@"apparel t1:7 For All Mankind"];
//    [da updateUserTotalCoinByDelta:123];
//    [da updateUserTotalCoinByDelta:-3];
    
    [da updateGroupScoreAndRightQuizAmount:@"apparel t1:group 2" andScore:10 andRightQuizAmount:11];
    [da updateGroupScoreAndRightQuizAmount:@"apparel t1:group 2" andScore:15 andRightQuizAmount:22];

//    [da updateGroupLockState:@"apparel t1:group 2" andLocked:1];
//    [da updateGroupLockState:@"apparel t1:group 2" andLocked:2];
    
//    [da updatePackageLockState:@"apparel t1" andLocked:1];

}













@end
