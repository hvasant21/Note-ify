//
//  NotesEditViewController.h
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileObject.h"

@protocol NotesEditViewControllerDelegate <NSObject>

- (void)shouldUpdateNoteWithFile:(FileObject*)file withContent:(NSString*)content;

@end

@interface NotesEditViewController : UIViewController
@property(nonatomic,weak) id<NotesEditViewControllerDelegate> delegate;
@property(nonatomic,strong) FileObject* file;


@end



