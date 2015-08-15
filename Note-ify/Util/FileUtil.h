//
//  FileUtil.h
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject

+ (void)createFileWithContent:(NSString*)content atPath:(NSString*)localPath;
+ (NSString*)getDirectoryPathForFilename:(NSString*)name;
+ (BOOL)removeFileAtPath:(NSString*)filePath withError:(NSError**)error;
+ (NSString*)getContentOfFileWithFilePath:(NSString*)filePath;
+ (BOOL)moveFileFromPath:(NSString*)sourcePath toDestinationPath:(NSString*)destinationPath;
+ (NSString*) GetRandomFileName;
@end
