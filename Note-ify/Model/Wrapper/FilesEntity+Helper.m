//
//  FilesEntity+Helper.m
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "FilesEntity+Helper.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FileObject.h"
#import "FileUtil.h"
#import "DropBoxSessionManager.h"

@implementation FilesEntity (Helper)

#pragma - mark Public Methods

//Get all files entity which is to be synced to server
+ (NSArray*)getAllFilesToBeSynced
{
    NSString* userID = [[DropBoxSessionManager sharedManager] currentUserId];
    NSMutableArray* filesObjectArray = [[NSMutableArray alloc] init];
    
    int syncStatusSynced = (int)SyncStatusSynced;
    NSArray* fileArray =[FilesEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"syncStatus != %d  AND userID = '%@'",syncStatusSynced,userID]]];
    
    for(FilesEntity *fileEntity in fileArray)
    {
        FileObject* file = [self convertEntityToObject:fileEntity];
        [filesObjectArray addObject:file];
    }
    
    return filesObjectArray;
    
    
}

//Get files all files entity which are present locally.

+ (NSArray*)getAllExistingFiles
{
    NSString* userID = [[DropBoxSessionManager sharedManager] currentUserId];
    
    NSMutableArray* filesObjectArray = [[NSMutableArray alloc] init];
    
    NSArray* fileArray =[FilesEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat: @"syncStatus != '%d' AND userID = '%@'",(int)SyncStatusDeleted,userID]]];
    
    for(FilesEntity *fileEntity in fileArray)
    {
        FileObject* file = [self convertEntityToObject:fileEntity];
        [filesObjectArray addObject:file];
    }
    
    return filesObjectArray;
    
    
}


//Add or update a file entry
+ (BOOL)addOrUpdateFileObject:(FileObject*)fileObject
{
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        FilesEntity* fileEntity = nil;
        
        do {
            fileEntity = [FilesEntity getFileEntityWithName:fileObject.name inContext:localContext];
            if(!fileEntity)
            {
                fileEntity = [FilesEntity MR_createEntityInContext:localContext];
            }
            if (![fileObject.name isKindOfClass:[NSNull class]] && fileObject.name.length > 0) {
                fileEntity.name = fileObject.name;
            }
            
            if (![fileObject.fileRevision isKindOfClass:[NSNull class]] && fileObject.fileRevision.length > 0) {
                fileEntity.fileRevision = fileObject.fileRevision;
            }
            
            fileEntity.syncStatus = fileObject.syncStatus;
            fileEntity.title = fileObject.title;
            
            fileEntity.userID = [[DropBoxSessionManager sharedManager] currentUserId];
            
            if (![fileObject.remotePath isKindOfClass:[NSNull class]] && fileObject.remotePath.length > 0) {
                fileEntity.remotePath = fileObject.remotePath;
            }
            
        }while(NO);
    }];
    
    return YES;
}


+ (FileObject*)getFileObjectWithName:(NSString*)fileName
{
    FileObject* fileObj = nil;
    FilesEntity* fileEntity = [self getFileEntityWithName:fileName inContext:[NSManagedObjectContext MR_defaultContext]];
    if(fileEntity)
    {
        fileObj = [self convertEntityToObject:fileEntity];
    }
    return fileObj;
}


//Delete a file object from DB
+ (void)deleteFileObject:(FileObject*)fileObject
{
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        FilesEntity* fileEntity = nil;
        
        do {
            fileEntity = [FilesEntity getFileEntityWithName:fileObject.name inContext:localContext];
            if (fileEntity) {
                [fileEntity MR_deleteEntityInContext:localContext];
            }
        }while(NO);
    }];
}

#pragma - mark Private Methods

+ (FilesEntity*)getFileEntityWithName:(NSString*)fileName inContext:(NSManagedObjectContext*)context
{
    NSString* userID = [[DropBoxSessionManager sharedManager] currentUserId];
    FilesEntity* fileEntity =[FilesEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat: @" name = '%@' AND userID = '%@'",fileName,userID]] inContext:context];
    return fileEntity;
}

+ (FileObject*)convertEntityToObject:(FilesEntity*)file
{
    FileObject* fileObj = [[FileObject alloc] init];
    fileObj.name = file.name;
    fileObj.syncStatus = file.syncStatus;
    fileObj.localPath = [FileUtil getDirectoryPathForFilename:file.name];
    fileObj.remotePath = file.remotePath;
    fileObj.fileRevision = file.fileRevision;
    fileObj.title = file.title;
    return fileObj;
}


@end
