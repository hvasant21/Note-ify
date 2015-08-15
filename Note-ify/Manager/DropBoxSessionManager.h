//
//  DropBoxSessionManager.h
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SingletonClass.Template.h"

static NSString * const refreshNotes = @"REFRESH_NOTES";

@interface DropBoxSessionManager : NSObject
declareSingleton(DropBoxSessionManager);

- (BOOL)checkOpenURL:(NSURL *)url;
- (void) doLogout;
@end
