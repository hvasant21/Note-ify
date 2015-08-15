//
//  FileObject.h
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <Foundation/Foundation.h>


@class DBMetadata;

//Sync status pertaining to local copy of files.

typedef enum _SyncStatus{
    SyncStatusCreated = 0,
    SyncStatusUpdated,
    SyncStatusDeleted,
    SyncStatusSynced
}SyncStatus;

@interface FileObject : NSObject

@property (nonatomic, copy) NSString *  name;
@property (nonatomic, assign) SyncStatus  syncStatus;
@property (nonatomic, copy) NSString *  localPath;
@property (nonatomic, copy) NSString *  remotePath;
@property (nonatomic, copy) NSString *  fileRevision;
@property (nonatomic, copy) NSString *  title;

@end
