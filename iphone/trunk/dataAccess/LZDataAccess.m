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
        shared = [[LZDataAccess alloc] initDBConnection];
    });
    return shared;
}

- (id)initDBConnection{
    self = [super init];
    if (self) {
        NSString *dbFilePath = [self dbFilePath];
        dbfm = [FMDatabase databaseWithPath:dbFilePath];
        if (![dbfm open]) {
            //[dbfm release];
            NSLog(@"initDBConnection, FMDatabase databaseWithPath failed, %@", dbFilePath);
        }
    }
    return self;
}

//TODO check programmar
- (void)finalize {
    NSLog(@"LZDataAccess finalize begin");
    [dbfm close];
    [super finalize];
}
//TODO check programmar
- (void)dealloc {
    NSLog(@"LZDataAccess dealloc begin");
    [dbfm close];    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
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



//SELECT pd1.name name,seq,locked,price, groupCount,passedGroupCount,quizCount,scoreSum
//  FROM
//    packageDef pd1,
//    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,
//    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount
//      FROM packageDef pd LEFT OUTER JOIN (
//        SELECT gd.pkgkey, count(gd.grpkey) groupCount
//          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//          WHERE gr.passed=1
//          GROUP BY gd.pkgkey
//        ) pgc1 ON pd.name=pgc1.pkgkey
//    ) pgpc,
//    (SELECT gd.pkgkey,count(qd.quizkey) quizCount
//      FROM groupDef gd, quizDef qd
//      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey
//    ) pqc,
//    (SELECT pd.name name, sum(ifnull(gr.gotScoreSum,0)) scoreSum
//      FROM packageDef pd JOIN groupDef gd ON pd.name=gd.pkgkey
//        LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey
//      GROUP BY pd.name
//    ) ps
//  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey and pd1.name=ps.name
//  ORDER BY seq
- (NSArray *)getPackages {
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
////        //[dbfm release];
////        return;
//        NSLog(@"open db failed, %@", dbFilePath);
//    }

    NSMutableArray *pkgAry = [NSMutableArray arrayWithCapacity:10];
    NSString *query = @""
    "SELECT pd1.name name,seq,locked,price, groupCount,passedGroupCount,quizCount,scoreSum"
    "  FROM"
    "    packageDef pd1, "
    "    (SELECT pkgkey, count(grpkey) groupCount FROM groupDef GROUP BY pkgkey) pgc,"
    "    (SELECT pd.name pkgkey, ifnull(pgc1.groupCount,0) passedGroupCount"
    "      FROM packageDef pd LEFT OUTER JOIN ("
    "        SELECT gd.pkgkey, count(gd.grpkey) groupCount "
    "          FROM groupDef gd LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey"
    "          WHERE gr.passed=1 "
    "          GROUP BY gd.pkgkey"
    "        ) pgc1 ON pd.name=pgc1.pkgkey"
    "    ) pgpc,"
    "    (SELECT gd.pkgkey,count(qd.quizkey) quizCount"
    "      FROM groupDef gd, quizDef qd "
    "      WHERE gd.grpkey=qd.grpkey GROUP BY gd.pkgkey"
    "    ) pqc,"
    "    (SELECT pd.name name, sum(ifnull(gr.gotScoreSum,0)) scoreSum"
    "      FROM packageDef pd JOIN groupDef gd ON pd.name=gd.pkgkey"
    "        LEFT OUTER JOIN groupRun gr ON gd.grpkey=gr.grpkey"
    "      GROUP BY pd.name"
    "    ) ps"
    "  WHERE pd1.name=pgc.pkgkey and pd1.name=pgpc.pkgkey and pd1.name=pqc.pkgkey and pd1.name=ps.name"
    "  ORDER BY seq"
    ;
    FMResultSet *rs = [dbfm executeQuery:query];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [pkgAry addObject:rowDict];
    }
    NSLog(@"getPackages ret:\n%@",pkgAry);
//    [dbfm close];
    return pkgAry;
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
//  WHERE gd.pkgkey='apparel t1' ORDER BY seqInPkg
-(NSArray *) getPackageGroups:(NSString *)pkgkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    
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
    "  WHERE gd.pkgkey=:pkgkey ORDER BY seqInPkg"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:pkgkey, @"pkgkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    while ([rs next]) {
        NSDictionary *rowDict = rs.resultDictionary;
        [grpAry addObject:rowDict];
    }
    NSLog(@"getPackageGroups ret:\n%@",grpAry);
//    [dbfm close];
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
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    
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
//    [dbfm close];
    return quizAry;
}

//SELECT quizkey, answerPic, grpkey, pkgkey
//  FROM quizDef qd
//  WHERE qd.pkgkey IN (SELECT pkgkey FROM quizDef WHERE grpkey='apparel t1:group 1')
//    and qd.grpkey<>'apparel t1:group 1'
//  LIMIT 1
-(NSArray *) getGroupQuizOptions:(NSString *)grpkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
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
//    [dbfm close];
    return quizOptionAry;
}


//SELECT qd.quizkey, awardCoin, awardScore, ifnull(haveAwardCoin,0) haveAwardCoin
//  FROM quizDef qd JOIN groupDef gd ON qd.grpkey=gd.grpkey
//    LEFT OUTER JOIN quizRun qr ON qd.quizkey=qr.quizkey
//  WHERE qd.quizkey='apparel t1:Abercrombie & Fitch'
/*
 除了标记haveAwardCoin，还会修改user的totalCoin。
 */
-(NSDictionary *)obtainQuizAward:(NSString *)quizkey{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
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
    //NSLog(@"obtainQuizAward dictquizInfo:\n%@",dictquizInfo);

    NSNumber *haveAwardCoinNoNullObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoinNoNull"];
    NSNumber *haveAwardCoinObj = (NSNumber *)[dictquizInfo objectForKey:@"haveAwardCoin"];
    NSNumber *awardCoin = (NSNumber *)[dictquizInfo objectForKey:@"awardCoin"];
    NSNumber *awardScore = (NSNumber *)[dictquizInfo objectForKey:@"awardScore"];
    //NSLog(@"in obtainQuizAward haveAwardCoinObj=%@, haveAwardCoinNoNullObj=%@", haveAwardCoinObj, haveAwardCoinNoNullObj);

    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    int haveAwardCoin = [haveAwardCoinNoNullObj intValue];
    if(haveAwardCoin == 1){
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardCoin"];
        [retDict setValue:[NSNumber numberWithInt:0] forKey:@"awardScore"];
    }else{
        NSString *updateQuizSql;
        
        if ([haveAwardCoinObj isEqual:[NSNull null]]){
            updateQuizSql = @"INSERT INTO quizRun(quizkey,haveAwardCoin) VALUES (:quizkey,:haveAwardCoin)";
        }else{
            updateQuizSql = @"UPDATE quizRun SET haveAwardCoin=:haveAwardCoin WHERE quizkey=:quizkey";
        }
        //NSLog(@"in obtainQuizAward updateQuizSql=%@", updateQuizSql);

        NSDictionary *dictUpdateQuiz = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:1], @"haveAwardCoin",
                                            quizkey, @"quizkey",nil];
        //BOOL updateRet = [dbfm executeUpdate:updateQuizSql withParameterDictionary:dictUpdateQuiz];
        NSError *outErr = Nil;
        BOOL updateRet = [dbfm executeUpdate:updateQuizSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdateQuiz orVAList:nil];
        if (outErr != nil)
            NSLog(@"in obtainQuizAward outErr=%@", outErr);
        if (!updateRet)
            NSLog(@"in obtainQuizAward executeUpdate, up quiz Failed");
        
        [self updateUserTotalCoinByDelta:[awardCoin intValue]];
        
        //NSLog(@"in obtainQuizAward updateRet=%d", updateRet);
        [retDict setValue:haveAwardCoinNoNullObj forKey:@"haveAwardCoin"];
        [retDict setValue:awardCoin forKey:@"awardCoin"];
        [retDict setValue:awardScore forKey:@"awardScore"];
    }
//    [dbfm close];
    return retDict;
}


-(BOOL) updateUserTotalCoinByDelta:(int) totalCoinDelta{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSString *updateSql = @"UPDATE user SET totalCoin=totalCoin+:delta WHERE 1=1";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:totalCoinDelta], @"delta",nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateUserTotalCoinByDelta executeUpdate outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateUserTotalCoinByDelta executeUpdate Failed");
//    [dbfm close];
    return updateRet;
}

-(NSDictionary *) getUserTotalScore{
    NSDictionary *rowDict = Nil;
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"open db failed, %@", dbFilePath);
//    }
    NSString *query = @"SELECT name, totalScore, totalCoin FROM user";
    FMResultSet *rs = [dbfm executeQuery:query];
    if ([rs next]) {
        rowDict = rs.resultDictionary;
    }
//    [dbfm close];
    NSLog(@"getUserTotalScore ret:\n%@",rowDict);
    return rowDict;
}


/*
 当前的值与老的值相比，取较大的更新
 */
-(NSDictionary *)updateGroupScoreAndRightQuizAmount:(NSString *)grpkey andScore:(int)score andRightQuizAmount:(int)rightQuizAmount{
//    NSString *dbFilePath = [self dbFilePath];
//    FMDatabase *dbfm = [FMDatabase databaseWithPath:[self dbFilePath]];
//    if (![dbfm open]) {
//        //        //[dbfm release];
//        //        return;
//        NSLog(@"FMDatabase open failed, %@", dbFilePath);
//    }
    NSString *query = @""
    "SELECT grpkey, gotScoreSum, answerRightMax FROM groupRun WHERE grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictGrpInfo;
    if ([rs next]) {
        dictGrpInfo = rs.resultDictionary;
    }else{
        NSString *insertSql = @"INSERT INTO groupRun(grpkey,gotScoreSum,answerRightMax) VALUES (:grpkey,:gotScoreSum,:answerRightMax)";
        NSDictionary *dictInsert = [NSDictionary dictionaryWithObjectsAndKeys:
                                     grpkey,@"grpkey",
                                     [NSNumber numberWithInt:score], @"gotScoreSum",
                                     [NSNumber numberWithInt:rightQuizAmount], @"answerRightMax",
                                     nil];
        NSError *outErr = Nil;
        BOOL insertRet = [dbfm executeUpdate:insertSql error:&outErr withArgumentsInArray:nil orDictionary:dictInsert orVAList:nil];
        if (outErr != nil)
            NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate insertSql outErr=%@", outErr);
        if (!insertRet)
            NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate insertSql Failed");
//        [retDict setObject:[NSNumber numberWithInt:score] forKey:@"gotScoreSum"];
//        [retDict setObject:[NSNumber numberWithInt:rightQuizAmount] forKey:@"answerRightMax"];
        [self updateUserTotalCoinByDelta:score];
        NSLog(@"updateGroupScoreAndRightQuizAmount dictInsert=%@",dictInsert);
        return dictInsert;
    }
    NSNumber *gotScoreSumNmOld = [dictGrpInfo objectForKey:@"gotScoreSum"];
    NSNumber *answerRightMaxNmOld = [dictGrpInfo objectForKey:@"answerRightMax"];
    int gotScoreSum = [gotScoreSumNmOld intValue];
    int answerRightMax = [answerRightMaxNmOld intValue];
    if (gotScoreSum < score)
        gotScoreSum = score;
    if (answerRightMax < rightQuizAmount)
        answerRightMax = rightQuizAmount;
    
    NSString *updateSql = @"UPDATE groupRun SET gotScoreSum=:gotScoreSum , answerRightMax=:answerRightMax WHERE grpkey=:grpkey";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:                                 
                                 [NSNumber numberWithInt:gotScoreSum], @"gotScoreSum",
                                 [NSNumber numberWithInt:answerRightMax], @"answerRightMax",
                                 grpkey,@"grpkey",
                                 nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate updateSql outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateGroupScoreAndRightQuizAmount executeUpdate updateSql Failed");
    NSLog(@"updateGroupScoreAndRightQuizAmount dictUpdate=%@",dictUpdate);
    
    int scoreDelta = gotScoreSum - [gotScoreSumNmOld intValue];
    if (scoreDelta > 0){
        [self updateUserTotalCoinByDelta:scoreDelta];
    }
//    [dbfm close];
    return dictUpdate;
}

-(BOOL)updateGroupLockState:(NSString *)grpkey andLocked:(int)locked{
    NSString *query = @""
    "SELECT grpkey, locked FROM groupRun WHERE grpkey=:grpkey"
    ;
    NSDictionary *dictQueryParam = [NSDictionary dictionaryWithObjectsAndKeys:grpkey, @"grpkey", nil];
    FMResultSet *rs = [dbfm executeQuery:query withParameterDictionary:dictQueryParam];
    NSDictionary *dictGrpInfo;
    if ([rs next]) {
        dictGrpInfo = rs.resultDictionary;
    }else{
        NSString *insertSql = @"INSERT INTO groupRun(grpkey,locked) VALUES (:grpkey,:locked)";
        NSDictionary *dictInsert = [NSDictionary dictionaryWithObjectsAndKeys:
                                    grpkey,@"grpkey",
                                    [NSNumber numberWithInt:locked], @"locked",
                                    nil];
        NSError *outErr = Nil;
        BOOL insertRet = [dbfm executeUpdate:insertSql error:&outErr withArgumentsInArray:nil orDictionary:dictInsert orVAList:nil];
        if (outErr != nil)
            NSLog(@"in updateGroupLockState executeUpdate insertSql outErr=%@", outErr);
        if (!insertRet)
            NSLog(@"in updateGroupLockState executeUpdate insertSql Failed");
        NSLog(@"updateGroupLockState dictInsert=%@",dictInsert);
        return insertRet;
    }
    NSNumber *lockedNmOld = [dictGrpInfo objectForKey:@"locked"];
    int lockedOld = [lockedNmOld intValue];
    if (lockedOld == locked){
        return TRUE;
    }
    
    NSString *updateSql = @"UPDATE groupRun SET locked=:locked WHERE grpkey=:grpkey";
    NSDictionary *dictUpdate = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:locked], @"locked",
                                grpkey,@"grpkey",
                                nil];
    NSError *outErr = Nil;
    BOOL updateRet = [dbfm executeUpdate:updateSql error:&outErr withArgumentsInArray:nil orDictionary:dictUpdate orVAList:nil];
    if (outErr != nil)
        NSLog(@"in updateGroupLockState executeUpdate updateSql outErr=%@", outErr);
    if (!updateRet)
        NSLog(@"in updateGroupLockState executeUpdate updateSql Failed");
    NSLog(@"updateGroupLockState dictUpdate=%@",dictUpdate);
    return updateRet;
}










@end
