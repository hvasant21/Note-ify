//
//  DropBoxSessionManager.m
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "UIKit/UIKit.h"
#import "DropBoxSessionManager.h"
#import <DropboxSDK/DropboxSDK.h>

static NSString * const appKey = @"kjda3b7d59qlpvs";
static NSString * const appSecret = @"awjiday8w0urdqx";

@interface DropBoxSessionManager ()<DBSessionDelegate,DBNetworkRequestDelegate>
{
    NSString *relinkUserId;
}
@end

@implementation DropBoxSessionManager
defineSingleton(DropBoxSessionManager)

- (id)init
{
    if(self = [super init])
    {
 
    NSString *root = kDBRootAppFolder;
    
    
        DBSession* session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
        session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
        [DBRequest setNetworkRequestDelegate:self];
        [DBSession setSharedSession:session];
        [self setCurrentUser];
    }
    return self;
}

- (BOOL)checkOpenURL:(NSURL *)url
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:userLoggedIn object:nil];
        } else {
            // Login was canceled/failed.
        }
        return YES;
    }
    return NO;
}

- (BOOL)isLoggedIn
{
    BOOL isLinked = [[DBSession sharedSession] isLinked];
    return isLinked;
}

- (void)setCurrentUser
{
    if([[DBSession sharedSession] isLinked])
    {
        _currentUserId = [[DBSession sharedSession].userIds objectAtIndex:0];
    }
    else
    {
        _currentUserId = nil;
    }
}

- (void) doLogout
{
    [[DBSession sharedSession] unlinkAll];
}

#pragma mark -
#pragma mark DBSessionDelegate methods


- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session userId:(NSString *)userId {

    relinkUserId = userId;
    [[[UIAlertView alloc]
        initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
        cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil]
        show];
 
}



#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
    if (index != alertView.cancelButtonIndex) {
        
    }
    relinkUserId = nil;
}

#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted {
    outstandingRequests++;
    if (outstandingRequests == 1) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)networkRequestStopped {
    outstandingRequests--;
    if (outstandingRequests == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}
@end
