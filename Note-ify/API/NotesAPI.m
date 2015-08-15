//
//  NotesAPI.m
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesAPI.h"
#import "DropBoxManager.h"
#import "NotesEditUtil.h"
#import "FileUtil.h"
#import "FilesEntity+Helper.h"
#import <MagicalRecord/MagicalRecord.h>

#define ROOT_FOLDER @"/"

@interface NotesAPI ()<DBManagerDelegate>
{
    NSMutableArray* filesToSync;
}
@property(nonatomic,strong) DropBoxManager* dbManager;
@end

@implementation NotesAPI

- (id)init
{
    if(self = [super init])
    {
        _dbManager = [[DropBoxManager alloc]init];
        _dbManager.delegate = self;
    }
    return self;
}


#pragma -mark Public methods

//Get the files to be synced from DB and initiate file sync.

- (void)refreshFilesList
{
    filesToSync = [[FilesEntity getAllFilesToBeSynced] mutableCopy];
    [self initiateFileSync];
}

/*
 Update file content
  In params: Content    -> new file content
             fileObject -> file to be updated
 */

- (void)updateFileWithContent:(NSString*)content withFile:(FileObject*)fileObject
{
    if(fileObject.syncStatus == SyncStatusSynced)
    {
        fileObject.syncStatus = SyncStatusUpdated;
    }
    fileObject.title = [NotesEditUtil getTitleForNoteWithContent:content];
    [FileUtil createFileWithContent:content atPath:fileObject.localPath];
    [FilesEntity addOrUpdateFileObject:fileObject];
}


/*
 Delete file object
 In params:  fileObject -> file to be deleted
 */

- (void)deleteFileWithObject:(FileObject*)fileObject
{
    /*
     if
     file is present in server, needs to be deleted from server,so update syncStatus
     
     else
     file has not been synced yet,present locally so delete the file object from local path and DB
     */
    if(fileObject.syncStatus == SyncStatusSynced)
    {
        fileObject.syncStatus = SyncStatusDeleted;
        [FilesEntity addOrUpdateFileObject:fileObject];
    }
    else
    {
        [FileUtil removeFileAtPath:fileObject.localPath withError:nil];
        [FilesEntity deleteFileObject:fileObject];
    }
    
}


//Create new file object with content.

- (FileObject*)createNewFileEntityWithContent:(NSString*)content
{
    NSString* title = [NotesEditUtil getTitleForNoteWithContent:content];
    NSString* fileName = [FileUtil GetRandomFileName];
   
    NSString* localPath = [FileUtil getDirectoryPathForFilename:fileName];
    [FileUtil createFileWithContent:content atPath:localPath];
    
    FileObject* fileObject = [[FileObject alloc] init];
    fileObject.title = title;
    fileObject.localPath = localPath;
    fileObject.syncStatus = SyncStatusCreated;
    fileObject.name = fileName;
    [FilesEntity addOrUpdateFileObject:fileObject];
    return fileObject;
}

//Get files which are present locally
- (NSArray*)getAllExistingFiles
{
    return [FilesEntity getAllExistingFiles];
}


#pragma mark - Private methods

//Sync each fileobject from filesToSync array based on sync status.
//TODO: could be replaced with NSOperationQueue to serialize the operation.
//After files are synced a final fetchFilesFromServer is called to get current files list from server

- (void)initiateFileSync
{
    if(filesToSync.count > 0)
    {
        FileObject* object = [filesToSync firstObject];
        switch (object.syncStatus) {
            case SyncStatusUpdated:
            case SyncStatusCreated:
                [self addFileToServerWithObject:object];
                break;
                case SyncStatusDeleted:
                [_dbManager deleteFileFromPath:object.remotePath];
                break;
                
            default:
                break;
        }

    }
    else
    {
        //Get the value in server.
        [_dbManager fetchFilesFromServer];
    }
}


//Sync file object to server.

- (void)addFileToServerWithObject:(FileObject*)fileObject
{
    [_dbManager uploadFileWithName:fileObject.name withParentRev:fileObject.fileRevision withLocalPath:fileObject.localPath];
}

//Save synced file to DB only if it is present locally.This is To avoid file records present in server and not locally.

- (void)saveSyncedFiledInDB:(NSArray*)fileContentArray
{
    for(DBMetadata* fileMeta in fileContentArray)
    {
        //This check Can be removed on syncing  files from server to device.
        FileObject* fileObj = [FilesEntity getFileObjectWithName:fileMeta.filename];
        if(fileObj)
        {
            fileObj.syncStatus = SyncStatusSynced;
            [FilesEntity addOrUpdateFileObject:fileObj];
        }
    }
}


#pragma mark - DBManagerDelegate methods

//Callback on loading files

- (void)didLoadFilesWithContent:(DBMetadata *)metadata withError:(NSError *)error
{
    //Save file entities to db.
    if(!error)
    {
        NSArray* filesArray = metadata.contents;
        [self saveSyncedFiledInDB:filesArray];
    }
    
    if([_delegate respondsToSelector:@selector(didReceiveNotesWithError:)])
    {
        [_delegate didReceiveNotesWithError:error];
    }
    
}

//Callback on uploading the file from server.

- (void)didUploadFile:(NSString *)destinationPath fromPath:(NSString *)sourcePath withMetadata:(DBMetadata *)dbMetadata withError:(NSError *)error
{
    FileObject* fileObj = nil;
    if(filesToSync.count)
    {
        fileObj = [filesToSync firstObject];
        [filesToSync removeObjectAtIndex:0];
    }
    
    //Update file object in DB
    
    fileObj.fileRevision = dbMetadata.rev;
    fileObj.remotePath = destinationPath;
    if(fileObj.syncStatus != SyncStatusUpdated)
    {
        fileObj.syncStatus = SyncStatusSynced;
    }
    fileObj.fileRevision = dbMetadata.rev;
    [FilesEntity addOrUpdateFileObject:fileObj];
    
    //Trigger next file sync
    [self initiateFileSync];

    
}

//Callback on deleting the file from server.

- (void)didDeleteFileWithName:(NSString *)fileName WithError:(NSError *)error
{
    FileObject* fileObj = nil;
    if(filesToSync.count)
    {
        fileObj = [filesToSync firstObject];
        [filesToSync removeObjectAtIndex:0];
    }
    
    //Delete the file locally if it is successfully deleted from server.
    if(!error)
    {
        
        NSString* filePath = [FileUtil getDirectoryPathForFilename:fileObj.name];
        [FileUtil removeFileAtPath:filePath withError:nil];
        [FilesEntity deleteFileObject:fileObj];
    }
    
    //Trigger next file sync
    [self initiateFileSync];
   
}

@end
