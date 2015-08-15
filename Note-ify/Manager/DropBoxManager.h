//
//  DropBoxManager.h
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@protocol DBManagerDelegate <NSObject>

- (void)didLoadFilesWithContent:(DBMetadata*)metadata withError:(NSError*)error;
- (void)didUploadFile:(NSString*)destinationPath fromPath:(NSString*)sourcePath withMetadata:(DBMetadata*)dbMetadata withError:(NSError*)error;
- (void)didDeleteFileWithName:(NSString*)fileName WithError:(NSError*)error;

@end

@interface DropBoxManager : NSObject

@property(nonatomic,weak) id<DBManagerDelegate> delegate;


//Get All files from App Folder.
- (void)fetchFilesFromServer;
- (void)uploadFileWithName:(NSString*)fileName withParentRev:(NSString*)revision withLocalPath:(NSString*)localPath;
- (void)deleteFileFromPath:(NSString*)path;
@end
