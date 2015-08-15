//
//  NotesViewModel.h
//  Notes
//
//  Created by Harini Vasanthakumar on 11/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FileObject.h"

@protocol NotesViewModelDelegate <NSObject>

- (void)didFinishListUpdateListWithError:(NSError *)error;
@end

@interface NotesViewModel : NSObject
@property(nonatomic,weak) id<NotesViewModelDelegate> delegate;
@property(nonatomic,strong,readonly) NSArray* notesArray;

- (void)syncFiles;
- (void)updateFileWithObject:(FileObject*)fileObject withContent:(NSString*)content;
- (void)deleteFileWithObject:(FileObject*)fileObject;

- (BOOL)isLoggedIn;
- (void)doLogout;
- (void)doLogin:(id)sender;


@end
