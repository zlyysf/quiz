//
//  LZDataAccess.m
//  tSql
//
//  Created by Yasofon on 13-2-4.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZDataAccess.h"

@implementation LZDataAccess

+(LZDataAccess *)singleton {
    static dispatch_once_t pred;
    static LZDataAccess *shared;
    // Will only be run once, the first time this is called
    dispatch_once(&pred, ^{
        shared = [[LZDataAccess alloc] init];
    });
    return shared;
}

- (NSString *)dbFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:cDbFile];
}




- (void)initDb
{
    sqlite3 *db;
    if (sqlite3_open([[self dbFilePath] UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"sqlite3_open failed");
    }
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *initdbFileUrl = [bundle URLForResource:@"initdb2" withExtension:@"sql"];
    
    NSError *err = Nil;
    NSString *initSQL = [NSString stringWithContentsOfURL:initdbFileUrl encoding:NSUTF8StringEncoding error:&err];
    if (err != Nil)
        NSLog(@"get initdb.sql content error: %@ ", err);
    //NSLog(@"initdb.sql content: %@ ", initSQL);
    
    char *errorMsg;
    if (sqlite3_exec (db, [initSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"sqlite3_exec error: %s", errorMsg);
    }
    sqlite3_close(db);
    NSLog(@"initDb exit");
    
}


//SELECT pd1.name,seq,locked,price, groupCount,passedGroupCount,quizCount
//  FROM
//    packageDef pd1,
//    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,
//    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount
//      FROM packageDef pd LEFT OUTER JOIN (
//        SELECT gd.pkgkey, count(gd.grpkey) groupCount
//          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//          WHERE gr.passed=1 GROUP BY gd.pkgkey
//        ) pgc1 ON pd.name=pgc1.pkgkey
//    ) pgpc,
//    (SELECT gd.pkgkey,count(qd.quizkey) quizCount
//      FROM groupDef gd, quizDef qd
//      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey
//    ) pqc
//  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey
- (NSArray *)getPackages {
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
//        //[dbfm release];
//        return;
        NSLog(@"open db failed, %@", dbFilePath);
    }
    //TODO added score of package, order by seq
    NSMutableArray *pkgAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""
    "SELECT pd1.name name,seq,locked,price, groupCount,passedGroupCount,quizCount"
    "  FROM"
    "    packageDef pd1,"
    "    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,"
    "    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount"
    "      FROM packageDef pd LEFT OUTER JOIN ("
    "        SELECT gd.pkgkey, count(gd.grpkey) groupCount"
    "          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey"
    "          WHERE gr.passed=1 GROUP BY gd.pkgkey"
    "        ) pgc1 ON pd.name=pgc1.pkgkey"
    "    ) pgpc,"
    "    (SELECT gd.pkgkey,count(qd.quizkey) quizCount"
    "      FROM groupDef gd, quizDef qd"
    "      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey"
    "    ) pqc"
    "  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey"    
    ;
    FMResultSet *rs = [dbfm executeQuery:query];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [pkgAry addObject:rowDict];
    }
    NSLog(@"getPackages ret:\n%@",pkgAry);
    [dbfm close];
    return pkgAry;
}



-(NSDictionary *) getUserTotalScore{
    NSDictionary *rowDict = Nil;
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
        //        //[dbfm release];
        //        return;
        NSLog(@"open db failed, %@", dbFilePath);
    }
    NSString *query = @"SELECT name, totalScore, totalCoin FROM user";
    FMResultSet *rs = [dbfm executeQuery:query];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
    [dbfm close];
    NSLog(@"getUserTotalScore ret:\n%@",rowDict);
    return rowDict;
}

//SELECT gd.grpkey grpkey, name, pkgkey, seqInPkg,
//    ifnull(locked,0) locked, ifnull(passed,0) passed, ifnull(gotScoreSum,0) gotScoreSum, ifnull(answerRightMax,0) answerRightMax, quizCount
//  FROM groupDef gd
//    LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//    LEFT OUTER JOIN (
//      SELECT qd.grpkey,count(qd.quizkey) quizCount
//        FROM quizDef qd JOIN groupDef gd1 ON qd.grpkey=gd1.grpkey
//        WHERE gd1.pkgkey='apparel t1' GROUP BY qd.grpkey
//    ) gqc ON gd.grpkey=gqc.grpkey
//  WHERE gd.pkgkey='apparel t1'
//TODO  order by seq
-(NSArray *) getPackageGroups:(NSString *)pkgkey{
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
        //        //[dbfm release];
        //        return;
        NSLog(@"FMDatabase open failed, %@", dbFilePath);
    }
    
    NSMutableArray *grpAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""    
    "SELECT gd.grpkey grpkey, name, pkgkey, seqInPkg, "
    "    ifnull(locked,0) locked, ifnull(passed,0) passed, ifnull(gotScoreSum,0) gotScoreSum, ifnull(answerRightMax,0) answerRightMax, quizCount"
    "  FROM groupDef gd "
    "    LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey "
    "    LEFT OUTER JOIN ("
    "      SELECT qd.grpkey,count(qd.quizkey) quizCount "
    "        FROM quizDef qd JOIN groupDef gd1 ON qd.grpkey=gd1.grpkey "
    "        WHERE gd1.pkgkey=:pkgkey GROUP BY qd.grpkey"
    "    ) gqc ON gd.grpkey=gqc.grpkey"
    "  WHERE gd.pkgkey=:pkgkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:pkgkey, @"pkgkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [grpAry addObject:rowDict];
    }
    NSLog(@"getPackageGroups ret:\n%@",grpAry);
    [dbfm close];
    return grpAry;
}


-(NSArray *) getGroupQuizzes:(NSString *)grpkey{
    NSArray *quizAry = [self getGroupQuiz:grpkey];
    NSArray *quizOptionAry = [self getGroupQuizOptions:grpkey];
    int i, n, optIdx=0, optCount;
    n = quizAry.count;
    optCount = quizOptionAry.count;
    for(i=0; i<n; i++){
        int oi1 = optIdx++ % optCount;
        int oi2 = optIdx++ % optCount;
        int oi3 = optIdx++ % optCount;
        NSDictionary *opt1,*opt2,*opt3;
        opt1 = quizOptionAry[oi1];
        opt2 = quizOptionAry[oi2];
        opt3 = quizOptionAry[oi3];
        NSLog(@"getGroupQuizzes opt1=\n%@",opt1);
        NSLog(@"getGroupQuizzes opt2=\n%@",opt2);
        NSLog(@"getGroupQuizzes opt3=\n%@",opt3);
        
//        NSLog(@"getGroupQuizzes opt1 allKeys=\n%@",[opt1 allKeys]);
//        NSLog(@"getGroupQuizzes opt2 allKeys=\n%@",[opt2 allKeys]);
//        NSLog(@"getGroupQuizzes opt3 allKeys=\n%@",[opt3 allKeys]);

        NSArray * qzOptions = [NSArray arrayWithObjects:opt1,opt2,opt3,Nil];
        //NSArray * qzOptions = [NSArray arrayWithObjects:opt1,opt2,Nil];
        //NSLog(@"getGroupQuizzes qzOptions=\n%@",qzOptions);
        NSMutableDictionary *qzitem = (NSMutableDictionary *)quizAry[i];
        //NSLog(@"getGroupQuizzes setbefore qzitem=\n%@",qzitem);
        [qzitem setObject:qzOptions forKey:@"options"];
        //NSLog(@"getGroupQuizzes setafter qzitem=\n%@",qzitem);//cause strange error

    }//for i
    NSLog(@"getGroupQuizzes ret:\n%@",quizAry);
    return quizAry;
}

//SELECT qd.quizkey quizkey, grpkey, pkgkey, questionWord, answerPic,
//    ifnull(haveAwardCoin,0) haveAwardCoin, ifnull(haveAwardScore,0) haveAwardScore
//  FROM quizDef qd LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey WHERE qd.grpkey='apparel t1:group 1'
-(NSArray *) getGroupQuiz:(NSString *)grpkey{
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
        //        //[dbfm release];
        //        return;
        NSLog(@"FMDatabase open failed, %@", dbFilePath);
    }
    
    NSMutableArray *quizAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""
    "SELECT qd.quizkey quizkey, grpkey, pkgkey, questionWord, answerPic, "
    "    ifnull(haveAwardCoin,0) haveAwardCoin, ifnull(haveAwardScore,0) haveAwardScore"
    "  FROM quizDef qd LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey WHERE qd.grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [quizAry addObject:rowDict];
    }
    NSLog(@"getGroupQuiz ret:\n%@",quizAry);
    [dbfm close];
    return quizAry;
}

//SELECT quizkey, answerPic, grpkey, pkgkey
//  FROM quizDef qd
//  WHERE qd.pkgkey IN (SELECT pkgkey FROM quizDef WHERE grpkey='apparel t1:group 1')
//    and qd.grpkey<>'apparel t1:group 1'
//  LIMIT 1
-(NSArray *) getGroupQuizOptions:(NSString *)grpkey{
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
        //        //[dbfm release];
        //        return;
        NSLog(@"FMDatabase open failed, %@", dbFilePath);
    }
    NSMutableArray *quizOptionAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""    
    "SELECT quizkey, answerPic, grpkey, pkgkey"
    "  FROM quizDef qd"
    "  WHERE qd.pkgkey IN (SELECT pkgkey FROM quizDef WHERE grpkey=:grpkey)"
    "    and qd.grpkey<>:grpkey"
    "  LIMIT :limitCount"
    ;
    int limitCount = 30;//TODO get from ...
    NSNumber *nbLimitCount = [NSNumber numberWithInt:limitCount];
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey",nbLimitCount,@"limitCount", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [quizOptionAry addObject:rowDict];
    }
    NSLog(@"getGroupQuizOptions ret:\n%@",quizOptionAry);
    [dbfm close];
    return quizOptionAry;
}


//SELECT qd.quizkey, awardCoin, awardScore, ifnull(haveAwardCoin,0) haveAwardCoin
//  FROM quizDef qd JOIN groupDef gd ON qd.grpkey=gd.grpkey
//    LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey
//  WHERE qd.quizkey='apparel t1:Abercrombie & Fitch'
-(NSDictionary *)obtainQuizAward:(NSString *)quizkey{
    NSString *dbFilePath = [self dbFilePath];
    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
    if (![dbfm open]) {
        //        //[dbfm release];
        //        return;
        NSLog(@"FMDatabase open failed, %@", dbFilePath);
    }
    NSString *query = @""
    "SELECT qd.quizkey, awardCoin, awardScore, haveAwardCoin, ifnull(haveAwardCoin,0) haveAwardCoinNoNull"
    "  FROM quizDef qd JOIN groupDef gd ON qd.grpkey=gd.grpkey"
    "    LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey   "
    "  WHERE qd.quizkey=:quizkey"
    ;    
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:quizkey, @"quizkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictquizInfo;
    if ([rs next]) {
        dictquizInfo = rs.resultDictionary;
    }
    NSLog(@"obtainQuizAward dictquizInfo:\n%@",dictquizInfo);

    NSNumber *haveAwardCoinNoNullObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoinNoNull"];
    NSNumber *haveAwardCoinObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoin"];
    NSNumber *awardCoin = (NSNumber *)[dictquizInfo objectForKey:@"awardCoin"];
    NSNumber *awardScore = (NSNumber *)[dictquizInfo objectForKey:@"awardScore"];
    NSLog(@"in obtainQuizAward haveAwardCoinObj=%@, haveAwardCoinNoNullObj=%@", haveAwardCoinObj, haveAwardCoinNoNullObj);

    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int haveAwardCoin = [haveAwardCoinNoNullObj intValue];
    if(haveAwardCoin == 1){
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardScore"];
    }else{
        NSString *updateQuizSql;
        
        if ([haveAwardCoinObj isEqual:[NSNull null]]){//TODO to be check value
        //if ([[NSNull null] isEqual:haveAwardCoinNoNullObj]){//TODO to be check value
            updateQuizSql = @"INSERT INTO quizRun(quizkey,haveAwardCoin) VALUES (:quizkey,:haveAwardCoin)";
        }else{
            updateQuizSql = @"UPDATE quizRun SET haveAwardCoin=:haveAwardCoin WHERE quizkey=:quizkey";
        }
        NSLog(@"in obtainQuizAward updateQuizSql=%@", updateQuizSql);

        NSDictionary *dictUpdateQuiz = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:1], @"haveAwardCoin",
                                            quizkey, @"quizkey",nil];
        //BOOL updateRet = [dbfm executeUpdate:updateQuizSql withParameterDictionary:dictUpdateQuiz];
        NSError *outErr = Nil;
        BOOL updateRet = [dbfm executeUpdate:updateQuizSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdateQuiz orVAList:nil];
        if (outErr != nil)
            NSLog(@"in obtainQuizAward outErr=%@", outErr);            
        
        NSLog(@"in obtainQuizAward updateRet=%d", updateRet);
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:awardCoin forKey:@"awardCoin"];
        [retDict setValue:awardScore forKey:@"awardScore"];
    }
    [dbfm close];
    return retDict;
}
















@end
