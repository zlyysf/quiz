//
//  LZViewController.m
//  toolForPackage
//
//  Created by Yasofon on 13-3-18.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZViewController.h"
#import "LZFileOp.h"

@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGetValidNames:(id)sender {
    [LZFileOp getValidPackageNames];
    
}

- (IBAction)btnTooLongNameToFiles:(id)sender {
    //must run in simulator
    [LZFileOp do_TooLongIconFileNamesInPackages_SaveToFiles];
}
@end
