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

static NSString * const userLoggedIn = @"USER_LOGGED_IN";

@interface DropBoxSessionManager : NSObject
declareSingleton(DropBoxSessionManager);

@property(nonatomic,readonly,strong) NSString* currentUserId;
- (BOOL)checkOpenURL:(NSURL *)url;
- (void) doLogout;
- (BOOL)isLoggedIn;
- (void)setCurrentUser;
@end
