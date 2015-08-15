//
//  WaitingView.h
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitingView : UIView

+ (WaitingView *)waitingView;
- (void)setWaitingText:(NSString*)txt;
@end
