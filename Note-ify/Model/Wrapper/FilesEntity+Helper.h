//
//  FilesEntity+Helper.h
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "FilesEntity.h"
#import "FileObject.h"
@interface FilesEntity (Helper)

+ (NSArray*)getAllFilesToBeSynced;
+ (NSArray*)getAllExistingFiles;
+ (BOOL)addOrUpdateFileObject:(FileObject*)fileObject;
+ (FileObject*)getFileObjectWithName:(NSString*)fileName;
+ (void)deleteFileObject:(FileObject*)fileObject;
@end
