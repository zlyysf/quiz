//
//  LZDATest1.m
//  testDa
//
//  Created by Yasofon on 13-2-21.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDATest1.h"
#import "LZDataAccess+GenSql.h"

@implementation LZDATest1


+(void)checkInitData
{
    LZDataAccess *da = [LZDataAccess singleton];
    
    
    NSArray * pkgAry = [da getPackages];
    if (pkgAry.count != 4){
        NSLog(@"init data, packages count ERROR");
    }
    
    NSString *pkgkey = @"Apparel 1";
    NSArray * pkgGroups = [da getPackageGroups:pkgkey];
    if (pkgGroups.count != 4){
        NSLog(@"init data, package groups count ERROR");
    }
    
    NSArray* rows = [da selectTableByEqualFilter:@"packageDef" andField:@"name" andValue:pkgkey];
    if (rows.count != 1){
        NSLog(@"selectTableByEqualFilter ERROR");
    }
    
    
    NSString *grpkey = [pkgGroups[0] objectForKey:@"grpkey"];
    NSArray * grpQuizzes = [da getGroupQuizzes:grpkey];
    if (grpQuizzes.count != 10){
        NSLog(@"init data, group quizzes count ERROR");
    }
    NSDictionary *quiz = grpQuizzes[0];
    NSArray * qzOptions = [quiz objectForKey:@"options"];
    if (qzOptions.count != 3){
        NSLog(@"init data, quiz options count ERROR");
    }
    
    if ([[pkgGroups[0] objectForKey:@"passRate"] integerValue] != 8){
        NSLog(@"init data, group passRate set in group ERROR");
    }
    if ([[pkgGroups[1] objectForKey:@"passRate"] integerValue] != 7){
        NSLog(@"init data, group passRate set in package ERROR");
    }
    
    
    
    //-------------
    NSDictionary *userInfo1 = [da getUserTotalScore];
    if([[userInfo1 objectForKey:@"totalCoin"] integerValue]!=0){
        NSLog(@"init data, user totalCoin ERROR");
    }
    
    NSString *quizkey = [quiz objectForKey:@"quizkey"];
    [da obtainQuizAward:quizkey];
    
    NSDictionary *userInfo2 = [da getUserTotalScore];
    if([[userInfo2 objectForKey:@"totalCoin"] integerValue]!=1){
        NSLog(@"obtainQuizAward 1 about coin ERROR");
    }
    
    NSDictionary *userInfo3 = [da getUserTotalScore];
    [da obtainQuizAward:quizkey];
    if([[userInfo3 objectForKey:@"totalCoin"] integerValue]!=1){
        NSLog(@"obtainQuizAward 2 about coin ERROR");
    }
    
    //--------------
       
    //--------------
    
    NSLog(@"checkInitData end");
}

+(void)check_updateGroupScoreAndRightQuizAmount{
    LZDataAccess *da = [LZDataAccess singleton];
    
    NSArray * pkgAry1 = [da getPackages];
    
    NSString *pkgkey = [pkgAry1[0] objectForKey:@"name"]; //@"Apparel 1";
    NSArray * pkgGroups = [da getPackageGroups:pkgkey];
    NSString *grpkey = [pkgGroups[0] objectForKey:@"grpkey"];

    NSArray * pkgGroups2 = pkgGroups;//[da getPackageGroups:pkgkey];
    NSDictionary *grp2 = [LZDataAccess findRowByKey:pkgGroups2 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp2 != nil && [[grp2 objectForKey:@"gotScoreSum"] integerValue]==0
       && [[grp2 objectForKey:@"answerRightMax"] integerValue]==0
       && [[grp2 objectForKey:@"passed"] integerValue]==0){
        //ok
    }else{
        NSLog(@"before updateGroupScoreAndRightQuizAmount, data ERROR");
    }
    
    int score1=500;
    int rightQuizAmount1 = 5;
    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score1 andRightQuizAmount:rightQuizAmount1];
    NSArray * pkgGroups3 = [da getPackageGroups:pkgkey];
    NSDictionary *grp3 = [LZDataAccess findRowByKey:pkgGroups3 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp3 != nil && [[grp3 objectForKey:@"gotScoreSum"] integerValue]==score1
       && [[grp3 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount1
       && [[grp3 objectForKey:@"passed"] integerValue]==0){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 1 ERROR");
    }
    
    int score2=900;
    int rightQuizAmount2 = 9;
    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score2 andRightQuizAmount:rightQuizAmount2];
    NSArray * pkgGroups4 = [da getPackageGroups:pkgkey];
    NSDictionary *grp4 = [LZDataAccess findRowByKey:pkgGroups4 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp4 != nil && [[grp4 objectForKey:@"gotScoreSum"] integerValue]==score2
       && [[grp4 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount2
       && [[grp4 objectForKey:@"passed"] integerValue]==1){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 2 ERROR");
    }
    
    NSArray * pkgAry2 = [da getPackages];
    if ([[pkgAry1[0] objectForKey:@"passedGroupCount"] intValue]==0 && [[pkgAry2[0] objectForKey:@"passedGroupCount"] intValue]==1){
        //ok
        NSLog(@"passedGroupCount OK");
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 2, passedGroupCount ERROR");
    }
    

    
    
    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score1 andRightQuizAmount:rightQuizAmount1];
    NSArray * pkgGroups5 = [da getPackageGroups:pkgkey];
    NSDictionary *grp5 = [LZDataAccess findRowByKey:pkgGroups5 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp5 != nil && [[grp5 objectForKey:@"gotScoreSum"] integerValue]==score2
       && [[grp5 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount2
       && [[grp5 objectForKey:@"passed"] integerValue]==1){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 3 ERROR");
    }

}

+ (void)testFunc1{
//    LZDataAccess *da = [LZDataAccess singleton];
//    [da cleanDb];
//    [da initDbByGeneratedSql];
//        
//    [self checkInitData];
//        
//    NSLog(@"testFunc1 end");    
}



+ (void)testFunc2{
    NSLog(@"testFunc2 enter");
    LZDataAccess *da = [LZDataAccess singleton];
    
    [da cleanDb];
    [da initDbWithGeneratedSql];

    [self checkInitData];
    [self check_updateGroupScoreAndRightQuizAmount];
    
    NSLog(@"testFunc2 end");
}

+ (void)testFunc22{
    NSLog(@"testFunc22 enter");

    LZDataAccess *da = [LZDataAccess singleton];
    
   
    [da initDbWithGeneratedSql];
    
    [self checkInitData];
    [self check_updateGroupScoreAndRightQuizAmount];

    
    NSLog(@"testFunc22 end");
}

+ (void)testFunc3{
    LZDataAccess *da = [LZDataAccess singleton];
    
    [da cleanDb];
    [da initDbWithGeneratedSql];
    [da initDbWithGeneratedSql];
    
    [self checkInitData];
    [self check_updateGroupScoreAndRightQuizAmount];

    
    NSLog(@"testFunc3 end");
}










@end
