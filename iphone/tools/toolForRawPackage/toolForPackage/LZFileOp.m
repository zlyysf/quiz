//
//  LZFileOp.m
//  toolForPackage
//
//  Created by Yasofon on 13-3-18.
//  Copyright (c) 2013年 Yasofon. All rights reserved.
//

#import "LZFileOp.h"
#import "LZTool.h"

@implementation LZFileOp

+(NSArray*)getValidPackageNames
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *validPkgNameFileUrl = [bundle URLForResource:@"validPackageName" withExtension:@"txt"];
    
    NSError *err = Nil;
    NSString *validPkgNamesStr = [NSString stringWithContentsOfURL:validPkgNameFileUrl encoding:NSUTF8StringEncoding error:&err];
    if (err != Nil){
        NSLog(@"getValidPackageNames error: %@ ", err);
        return nil;
    }
    //NSString * separator = @"\n\r";
    NSCharacterSet *sepCharSet = [NSCharacterSet newlineCharacterSet];
    NSArray *ary = [validPkgNamesStr componentsSeparatedByCharactersInSet:sepCharSet];
    NSMutableArray *validNames = [NSMutableArray arrayWithCapacity:ary.count];
    
    for(int i=0; i<ary.count; i++){
        NSString *name = [ary objectAtIndex:i];
        if (name.length > 0)
            [validNames addObject:name];
    }
    NSLog(@"getValidPackageNames return:%@",validNames);
    //NSDictionary *validNameDict = [NSDictionary dictionaryWithObjects:validNames forKeys:validNames];
    return validNames;
}



//+ (void)do_PackageFileNameTooLongWithoutExtToArrayInFile:(NSString *)pkgsDirPath andPackageName:(NSString *)pkgName
//{
//    NSString *pkgDirPath = [pkgsDirPath stringByAppendingPathComponent:pkgName];
//    
//    NSFileManager * defFileManager = [NSFileManager defaultManager];
//    NSError *err = Nil;
//    NSArray * shouldBeIconFiles = [defFileManager contentsOfDirectoryAtPath:pkgDirPath error:&err];
//    if (err != Nil){
//        NSLog(@"makePackageIconsIntoGroups contentsOfDirectoryAtPath err:%@",err);
//        err = nil;
//    }
//    NSMutableArray *fileNameWithoutExtAry = [[NSMutableArray alloc] initWithCapacity:shouldBeIconFiles.count];
//    for (NSString * shouldBeIconFileName in shouldBeIconFiles) {
//        if ([self isNormalPicFile:shouldBeIconFileName andDir:pkgDirPath]){
//            NSString *fileNameWithoutExt = [shouldBeIconFileName stringByDeletingPathExtension];
//            [fileNameWithoutExtAry addObject:fileNameWithoutExt];
//        }
//    }
//    
//    [fileNameWithoutExtAry sortedArrayUsingComparator:^(id obj1, id obj2){
//        NSString *s1 = obj1;
//        NSString *s2 = obj2;
//        return [s1 compare:s2];
//    }];
//    
//    NSString *fileNameArySaveFile = @"ary_fileName.plist";
//    NSString *fileNameArySaveFilePath = [pkgDirPath stringByAppendingPathComponent:fileNameArySaveFile];
//    [fileNameWithoutExtAry writeToFile:fileNameArySaveFilePath atomically:YES];
//    
//   
//    NSMutableArray *fileNamesTooLong = [NSMutableArray arrayWithCapacity:(fileNameWithoutExtAry.count/2)];
//    for(int i=0; i<fileNameWithoutExtAry.count; i++){
//        NSString *fileNameWithoutExt = [fileNameWithoutExtAry objectAtIndex:i];
//        if ( [LZTool textSizeTooHigh:fileNameWithoutExt] ){
//            [fileNamesTooLong addObject:fileNameWithoutExt];
//        }
//    }
//    NSString *fileNameTooLongArySaveFile = @"tooLongFiles.plist";
//    NSString *fileNameTooLongArySaveFilePath = [pkgDirPath stringByAppendingPathComponent:fileNameTooLongArySaveFile];
//    [fileNamesTooLong writeToFile:fileNameTooLongArySaveFilePath atomically:YES];
//
//}


+ (void)do_TooLongIconFileNamesInPackage_SaveToFile:(NSString *)pkgsDirPath andPackageName:(NSString *)pkgName
{
    NSString *pkgDirPath = [pkgsDirPath stringByAppendingPathComponent:pkgName];
    NSLog(@"do_TooLongIconFileNamesInPackage_SaveToFile pkgDirPath=%@",pkgDirPath);
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * shouldBeIconFiles = [defFileManager contentsOfDirectoryAtPath:pkgDirPath error:&err];
    if (err != Nil){
        NSLog(@"do_TooLongIconFileNamesInPackage_SaveToFile contentsOfDirectoryAtPath err:%@",err);
        err = nil;
    }
    
    NSMutableArray *fileNamesTooLong = [NSMutableArray arrayWithCapacity:shouldBeIconFiles.count];
    for (NSString * shouldBeIconFileName in shouldBeIconFiles) {
        if ([self isNormalPicFile:shouldBeIconFileName andDir:pkgDirPath]){
            if ( [LZTool fileNameWithoutExtSizeTooHigh:shouldBeIconFileName] ){
                [fileNamesTooLong addObject:shouldBeIconFileName];
            }           
        }
    }
    
    [fileNamesTooLong sortedArrayUsingComparator:^(id obj1, id obj2){
        NSString *s1 = obj1;
        NSString *s2 = obj2;
        return [s1 compare:s2];
    }];
    
    NSString *fileNameTooLongArySaveFile = @"tooLongFiles.plist";
    NSString *fileNameTooLongArySaveFilePath = [pkgDirPath stringByAppendingPathComponent:fileNameTooLongArySaveFile];
    [fileNamesTooLong writeToFile:fileNameTooLongArySaveFilePath atomically:YES];
}


+ (void)do_TooLongIconFileNamesInPackages_SaveToFiles
{
    NSArray *validPackageNames = [self getValidPackageNames];
    if (validPackageNames.count == 0){
        NSLog(@"WARN: NO valid package names configuration");
        return;
    }
    NSDictionary *validPkgDict = [NSDictionary dictionaryWithObjects:validPackageNames forKeys:validPackageNames];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = [bundle bundlePath];
    NSString *iconsPath = [bundlePath stringByAppendingPathComponent:@"icons"];
    NSString *pkgsDirPath = iconsPath;
    NSLog(@"do_TooLongIconFileNamesInPackages_SaveToFiles pkgsDirPath=%@",pkgsDirPath);
    
    NSFileManager * defFileManager = [NSFileManager defaultManager];
    NSError *err = Nil;
    NSArray * filesOrDirs = [defFileManager contentsOfDirectoryAtPath:pkgsDirPath error:&err];
    if (err != Nil){
        NSLog(@"do_TooLongIconFileNamesInPackage_SaveToFile contentsOfDirectoryAtPath err:%@",err);
        err = nil;
    }
    NSMutableArray *pkgNameAry = [[NSMutableArray alloc] initWithCapacity:filesOrDirs.count];
    for (NSString * fileOrDirName in filesOrDirs) {
        //NSString *fileOrDirPath = [pkgsDirPath stringByAppendingPathComponent:fileOrDirName];
        if( [self isNormalDir:fileOrDirName andDir:pkgsDirPath] ){
            if ( [validPkgDict objectForKey:fileOrDirName]!=nil ){
                [pkgNameAry addObject:fileOrDirName];
            }
        }
    }
    NSLog(@"do_TooLongIconFileNamesInPackages_SaveToFiles pkgNameAry=%@",pkgNameAry);
    
    for(int i=0; i<pkgNameAry.count; i++){
        NSString *pkgName = [pkgNameAry objectAtIndex:i];
        [self do_TooLongIconFileNamesInPackage_SaveToFile:pkgsDirPath andPackageName:pkgName ];
    }

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
