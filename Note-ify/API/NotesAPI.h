//
//  NotesAPI.h
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import "FileObject.h"

@protocol NotesApiDelegate <NSObject>

- (void)didReceiveNotesWithError:(NSError *)error;

@end

@interface NotesAPI : NSObject
@property(nonatomic,weak) id<NotesApiDelegate> delegate;

- (void)refreshFilesList;
- (void)updateFileWithContent:(NSString*)content withFile:(FileObject*)fileObject;
- (void)deleteFileWithObject:(FileObject*)fileObject;
- (FileObject*)createNewFileEntityWithContent:(NSString*)content;
- (NSArray*)getAllExistingFiles;
@end
