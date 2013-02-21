//
//  LZDATest1.m
//  testDa
//
//  Created by Yasofon on 13-2-21.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDATest1.h"

@implementation LZDATest1

+(NSDictionary *)findRowByKey:(NSArray *)rows andKeyName:(NSString *)keyname andKeyValue:(NSString *)keyvalue
{
    for(int i=0; i<rows.count; i++){
        NSDictionary *row = rows[i];
        NSString *columnVal = [row objectForKey:keyname];
        if ([columnVal isEqualToString:keyvalue]){
            return row;
        }
    }
    return nil;
}

+ (void)testFunc1{
    LZDataAccess *da = [LZDataAccess singleton];
    [da cleanDb];
    [da initDbByGeneratedSql];
    
    NSArray * pkgAry = [da getPackages];
    if (pkgAry.count != 4){
        NSLog(@"init data, packages count ERROR");
    }
    
    NSString *pkgkey = @"Apparel 1";
    NSArray * pkgGroups = [da getPackageGroups:pkgkey];
    if (pkgGroups.count != 4){
        NSLog(@"init data, package groups count ERROR");
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
    NSArray * pkgGroups2 = [da getPackageGroups:pkgkey];
    NSDictionary *grp2 = [self findRowByKey:pkgGroups2 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp2 != nil && [[grp2 objectForKey:@"gotScoreSum"] integerValue]==0 && [[grp2 objectForKey:@"answerRightMax"] integerValue]==0){
        //ok
    }else{
        NSLog(@"before updateGroupScoreAndRightQuizAmount, data ERROR");
    }
    
    int score1=500;
    int rightQuizAmount1 = 5;
    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score1 andRightQuizAmount:rightQuizAmount1];
    NSArray * pkgGroups3 = [da getPackageGroups:pkgkey];
    NSDictionary *grp3 = [self findRowByKey:pkgGroups3 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp3 != nil && [[grp3 objectForKey:@"gotScoreSum"] integerValue]==score1 && [[grp3 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount1){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 1 ERROR");
    }
    
    int score2=600;
    int rightQuizAmount2 = 6;
    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score2 andRightQuizAmount:rightQuizAmount2];
    NSArray * pkgGroups4 = [da getPackageGroups:pkgkey];
    NSDictionary *grp4 = [self findRowByKey:pkgGroups4 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp4 != nil && [[grp4 objectForKey:@"gotScoreSum"] integerValue]==score2 && [[grp4 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount2){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 2 ERROR");
    }

    [da updateGroupScoreAndRightQuizAmount:grpkey andScore:score1 andRightQuizAmount:rightQuizAmount1];
    NSArray * pkgGroups5 = [da getPackageGroups:pkgkey];
    NSDictionary *grp5 = [self findRowByKey:pkgGroups5 andKeyName:@"grpkey" andKeyValue:grpkey];
    if(grp5 != nil && [[grp5 objectForKey:@"gotScoreSum"] integerValue]==score2 && [[grp5 objectForKey:@"answerRightMax"] integerValue]==rightQuizAmount2){
        //ok
    }else{
        NSLog(@"updateGroupScoreAndRightQuizAmount 3 ERROR");
    }

    //--------------
    
    
    
    
    
    
    
    
    
    
    
    
    NSLog(@"testFunc1 end");

    
}

@end
