//
//  NotesViewModel.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//


#import "NotesViewModel.h"
#import "NotesAPI.h"
#import <DropBoxSDK/DropBoxSDK.h>
#import "FileObject.h"
#import "DropBoxSessionManager.h"

#define DEFAULT_FILE_NAME   @"Untitled text"
@interface NotesViewModel ()<NotesApiDelegate>
@property(nonatomic,strong) NotesAPI* notesApi;
@end
@implementation NotesViewModel



#pragma mark - Public methods

- (id)init
{
    if(self = [super init])
    {
        _notesApi = [[NotesAPI alloc] init];
        _notesApi.delegate = self;
    }
    return self;
}


#pragma mark - Create/Update/Delete methods

//Update/Create a file.

- (void)updateFileWithObject:(FileObject*)fileObject withContent:(NSString *)content
{
    //if file object is not present create a new one else update existing file.
    if(fileObject)
    {
        [_notesApi updateFileWithContent:content withFile:fileObject];
    }
    else
    {
        [_notesApi createNewFileEntityWithContent:content];
    }
    [self reloadFilesList];
}


//delete a file
- (void)deleteFileWithObject:(FileObject*)fileObject
{
    [_notesApi deleteFileWithObject:fileObject];
    [self reloadFilesList];
}



#pragma mark - Login/Logout methods

//Launch login page
- (void)doLogin:(id)sender
{
    [[DBSession sharedSession] linkFromController:sender];
    
}

//Check if user is logged in
- (BOOL)isLoggedIn
{
   
    return [[DropBoxSessionManager sharedManager] isLoggedIn];
}

//Logout of application.Unlink session manager
- (void)doLogout
{
    [[DropBoxSessionManager sharedManager] doLogout];
}

- (void)refreshSession
{
    [_notesApi refreshSession];
    [[DropBoxSessionManager sharedManager] setCurrentUser];
}

#pragma mark - Sync

//refresh files list ,check files to be created/updated and deleted and do the same.
- (void)syncFiles
{
    [_notesApi refreshFilesList];
}

#pragma mark - Private methods

//Refresh UI
- (void)reloadFilesList
{
    _notesArray = [_notesApi getAllExistingFiles];
    if([_delegate respondsToSelector:@selector(didFinishListUpdateListWithError:)])
    {
        [_delegate didFinishListUpdateListWithError:nil];
    }
}


#pragma mark - NotesAPI delegate methods
- (void)didReceiveNotesWithError:(NSError *)error
{
    [self reloadFilesList];
    
}



@end
