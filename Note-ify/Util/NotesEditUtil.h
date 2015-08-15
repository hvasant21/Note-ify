//
//  NotesEditUtil.h
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotesEditUtil : NSObject
+ (NSString*)getTitleForNoteWithContent:(NSString*)content;
+ (BOOL)isNoteValidWithContent:(NSString*)content;
@end
