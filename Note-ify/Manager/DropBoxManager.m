//
//  DropBoxManager.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DropBoxManager.h"
#import "FileUtil.h"

#define ROOT_FOLDER @"/"

@interface DropBoxManager ()<DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@end
@implementation DropBoxManager

- (id)init
{
    if(self = [super init])
    {
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
    }
    return self;
}

//Fetch files from App Folder
- (void)fetchFilesFromServer
{
    [self.restClient loadMetadata:ROOT_FOLDER];
}

//Upload file to update/create file.
/*
 if (revision)
    update file
 else
    create create
 */
- (void)uploadFileWithName:(NSString*)fileName withParentRev:(NSString*)revision withLocalPath:(NSString*)localPath
{
    [self.restClient uploadFile:fileName toPath:ROOT_FOLDER withParentRev:revision fromPath:localPath];
}

//Delte file from remote path
- (void)deleteFileFromPath:(NSString*)path
{
    [self.restClient deletePath:path];
}

#pragma mark - DBRestClientDelegate methods


- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    if([_delegate respondsToSelector:@selector(didUploadFile:fromPath:withMetadata:withError:)])
    {
        [_delegate didUploadFile:destPath fromPath:srcPath withMetadata:metadata withError:nil];
    }
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    if([_delegate respondsToSelector:@selector(didUploadFile:fromPath:withMetadata:withError:)])
    {
        [_delegate didUploadFile:nil fromPath:nil withMetadata:nil withError:error];
    }
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if([_delegate respondsToSelector:@selector(didLoadFilesWithContent:withError:)])
    {
        [_delegate didLoadFilesWithContent:metadata withError:nil];
    }
}

- (void)restClient:(DBRestClient *)client deletedPath:(NSString *)path
{
    if([_delegate respondsToSelector:@selector(didDeleteFileWithName:WithError:)])
    {
        [_delegate didDeleteFileWithName:path WithError:nil];
    }
}

- (void)restClient:(DBRestClient *)client deletePathFailedWithError:(NSError *)error
{
    if([_delegate respondsToSelector:@selector(didDeleteFileWithName:WithError:)])
    {
        [_delegate didDeleteFileWithName:nil WithError:error];
    }
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    if([_delegate respondsToSelector:@selector(didLoadFilesWithContent:withError:)])
    {
        [_delegate didLoadFilesWithContent:nil withError:error];
    }
}



@end
