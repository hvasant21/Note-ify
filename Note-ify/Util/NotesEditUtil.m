//
//  NotesEditUtil.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "NotesEditUtil.h"

@implementation NotesEditUtil

//Get title foe notes

+ (NSString*)getTitleForNoteWithContent:(NSString*)content
{
    NSString* processedContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* title = @"Unitiled text";
    if(processedContent.length>=30)
    {
         title = [processedContent substringToIndex:30];
    }
    else if(processedContent.length >0)
    {
         title = processedContent;
    }
    return title;
}

//Check if notes is valid

+ (BOOL)isNoteValidWithContent:(NSString*)content
{
    if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return false;
    }
    else
    {
        return true;
    }
}
@end
