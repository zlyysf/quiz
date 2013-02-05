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

- (IBAction)btnSelect_touchUpInside:(id)sender {
    //[da getPackages];
    //[da getPackageGroups:@"shoe t2"];
    //[da getGroupQuizzes:@"apparel t1:group 2"];
    //[da getGroupQuizOptions:@"apparel t1:group 2"];
    [da getUserTotalScore];
}

- (IBAction)btnUpdate_touchUpInside:(id)sender {
    [da obtainQuizAward:@"apparel t1:7 For All Mankind"];
    [da obtainQuizAward:@"apparel t1:7 For All Mankind"];

}













@end
