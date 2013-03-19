//
//  LZFileTool.m
//  toolmacForRawPackage
//
//  Created by Yasofon on 13-3-19.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZFileTool.h"

@implementation LZFileTool



+ (void)makePackagesIconsIntoGroups:(NSString *)pkgsParDirPath
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * filesOrDirs = [defFileManager contentsOfDirectoryAtPath:pkgsParDirPath error:&err];
    if (err != Nil){
        NSLog(@"makePackageIconsIntoGroups contentsOfDirectoryAtPath err:%@",err);
        err = nil;
    }
    NSMutableArray *pkgDirAry = [[NSMutableArray alloc] initWithCapacity:filesOrDirs.count];
    for (NSString * fileOrDirName in filesOrDirs) {
        NSString *fileOrDirPath = [pkgsParDirPath stringByAppendingPathComponent:fileOrDirName];
        if( [self isNormalDir:fileOrDirName andDir:pkgsParDirPath] ){
            [pkgDirAry addObject:fileOrDirPath];
        }
    }
    
    for(int i=0; i<pkgDirAry.count; i++){
        [self makePackageIconsIntoGroups:[pkgDirAry objectAtIndex:i] ];
    }
}

+ (void)makePackageIconsIntoGroups:(NSString *)pkgDirPath
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * filesOrDirs = [defFileManager contentsOfDirectoryAtPath:pkgDirPath error:&err];
    if (err != Nil){
        NSLog(@"makePackageIconsIntoGroups contentsOfDirectoryAtPath err:%@",err);
        err = nil;
    }
    
    NSMutableArray *fileNameAry = [[NSMutableArray alloc] initWithCapacity:filesOrDirs.count];
    NSString *tooLongFilesConfigFile = @"tooLongFiles.plist";
    NSString *tooLongFilesConfigFilePath = [pkgDirPath stringByAppendingPathComponent:tooLongFilesConfigFile];
    
    //    NSArray *tooLongFileNamesWithoutExt = [NSArray arrayWithContentsOfFile:tooLongFilesConfigFilePath];
    //    for (NSString * fileOrDirName in filesOrDirs) {
    //        if ([self isNormalPicFile:fileOrDirName andDir:pkgDirPath]
    //            && ![self isNameWithExtInNameWithoutExtArray:fileOrDirName andArray:tooLongFileNamesWithoutExt]
    //        ){
    //                [fileNameAry addObject:fileOrDirName];
    //        }
    //    }
    
    NSArray *tooLongFileNames = [NSArray arrayWithContentsOfFile:tooLongFilesConfigFilePath];
    for (NSString * fileOrDirName in filesOrDirs) {
        if ([self isNormalPicFile:fileOrDirName andDir:pkgDirPath]
            && ![self isStringInArray:fileOrDirName andArray:tooLongFileNames]
            ){
            [fileNameAry addObject:fileOrDirName];
        }
    }
    
    int groupFileCount = 10;
    int groupCount = fileNameAry.count / groupFileCount;
    for(int i=0; i<groupCount; i++){
        int groupSeq = i+1;
        NSString *groupDirName = [NSString stringWithFormat:@"group %d",groupSeq];
        NSString *groupDirPath = [pkgDirPath stringByAppendingPathComponent:groupDirName];
        
        [defFileManager createDirectoryAtPath:groupDirPath withIntermediateDirectories:YES attributes:nil error:&err];
        if (err != Nil){
            NSLog(@"makePackageIconsIntoGroups contentsOfDirectoryAtPath err:%@",err);
            err = nil;
        }
        
        for(int j=0; j<groupFileCount; j++){
            int randomIndex = arc4random() % fileNameAry.count;
            
            NSString *iconFileName = [fileNameAry objectAtIndex:randomIndex];
            [fileNameAry removeObjectAtIndex:randomIndex];
            NSString *fromIconFilePath = [pkgDirPath stringByAppendingPathComponent:iconFileName];
            NSString *toIconFilePath = [groupDirPath stringByAppendingPathComponent:iconFileName];
            
            [defFileManager moveItemAtPath:fromIconFilePath toPath:toIconFilePath error:&err];
            if (err != Nil){
                NSLog(@"makePackageIconsIntoGroups moveItemAtPath err:%@",err);
                err = nil;
            }
        }
    }
}



+(BOOL)isNameWithExtInNameWithoutExtArray:(NSString *) nameWithExt andArray:(NSArray *)nameWithoutExtArray{
    NSString *nameWithoutExt = [nameWithExt stringByDeletingPathExtension];
    for(NSString *name1 in nameWithoutExtArray){
        if ([name1 isEqualToString:nameWithoutExt]){
            return TRUE;
        }
    }
    return FALSE;
}

+(BOOL)isStringInArray:(NSString *) str andArray:(NSArray *)ary{
    for(NSString *str1 in ary){
        if ([str1 isEqualToString:str]){
            return TRUE;
        }
    }
    return FALSE;
}

+(BOOL)isNormalPicFile:(NSString *)fileName andDir:(NSString *)dirPath
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    BOOL fileExists,isDir;
    fileExists = [defFileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (fileExists && !isDir){
        if ([fileName characterAtIndex:0] == '.'){
            return FALSE;
        }else{
            NSString * extPart = [[fileName pathExtension] lowercaseString];
            if ([extPart isEqualToString:@"jpg"] || [extPart isEqualToString:@"jpeg"]
                || [extPart isEqualToString:@"png"] || [extPart isEqualToString:@"gif"]
                || [extPart isEqualToString:@"bmp"] || [extPart isEqualToString:@"tiff"]
                ){
                return TRUE;
            }else{
                return FALSE;
            }
        }
    }
    return FALSE;
}

+(BOOL)isNormalDir:(NSString *)dirName andDir:(NSString *)parDirPath
{
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSString *dirPath = [parDirPath stringByAppendingPathComponent:dirName];
    BOOL fileExists,isDir;
    fileExists = [defFileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (fileExists && isDir){
        if ([dirName characterAtIndex:0] == '.'){
            return FALSE;
        }else{
            return TRUE;
        }
    }
    return FALSE;
}





@end
