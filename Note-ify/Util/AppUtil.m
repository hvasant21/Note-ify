//
//  AppUtil.m
//  Note-ify
//
//  Created by Harini Vasanthakumar on 15/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "AppUtil.h"
#import "WaitingView.h"

@implementation AppUtil
{
    WaitingView *waitingView;
    UIWindow *window;
}
defineSingleton(AppUtil)

- (void) showWaitingViewWithText:(NSString*)text {
    
    window    =  [[[UIApplication sharedApplication] windows]
                  lastObject];
    if(nil == waitingView){
        waitingView =   [WaitingView waitingView];
    }
    [waitingView setFrame: [window bounds]];
    [waitingView setAlpha: 0.0];
   
    [waitingView setWaitingText:text];
    
    [window addSubview: waitingView];
    [window bringSubviewToFront: waitingView];
    
    [UIView animateWithDuration: 0.2 animations: ^{
        [waitingView setAlpha: 1.0];
    }];
}

- (void) hideWaitingView {
    [UIView animateWithDuration: 0.2 delay: 0.0 options: 0
                     animations: ^{
                         [waitingView setAlpha: 0.0];
                     }
                     completion: ^(BOOL finished) {
                         [waitingView removeFromSuperview];
                         waitingView    =   nil;
                     }];
}

@end
