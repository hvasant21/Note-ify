//
//  FileUtil.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

//Create file at path with content.
/*
 localPath -> local Path where file is to be saved
 content -> content to be saved
 */

+ (void)createFileWithContent:(NSString*)content atPath:(NSString*)localPath
{
    [content writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


+ (NSString*) DocumentDirectoryPath {
    return  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}


//Get full directory path for file name

+ (NSString*)getDirectoryPathForFilename:(NSString*)name
{
    NSString *rootDirectory = [FileUtil DocumentDirectoryPath];
    return  [rootDirectory stringByAppendingPathComponent:name];
}


//Delete file ar path

+ (BOOL)removeFileAtPath:(NSString*)filePath withError:(NSError**)error
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:filePath error:error];
    return success;
}


//move file (used to rename file or move to a different file path)

+ (BOOL)moveFileFromPath:(NSString*)sourcePath toDestinationPath:(NSString*)destinationPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL didMoveFile = [fileManager moveItemAtPath:sourcePath toPath:destinationPath error:&error];
    return didMoveFile;
}

//Get file content for file path

+ (NSString*)getContentOfFileWithFilePath:(NSString*)filePath
{
    NSString* content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

//Random file name

+ (NSString*) GetRandomFileName {
    NSString* fileName = [NSString stringWithFormat:@"%u.txt",[FileUtil GetRandomID]];
    return fileName;
}

#define RAND        (arc4random() % 255)
#define RANDOMUID   (RAND | (RAND << 8) | (RAND << 16) | (RAND << 24))


+ (unsigned int) GetRandomID {
    unsigned int uid = RANDOMUID;
    return ((uid > 0x10000000)? uid : [self GetRandomID]);
}


@end
