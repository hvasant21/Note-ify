//
//  AppUtil.h
//  Note-ify
//
//  Created by Harini Vasanthakumar on 15/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingletonClass.Template.h"

@interface AppUtil : NSObject
declareSingleton(AppUtil);

- (void) showWaitingViewWithText:(NSString*)text;
- (void) hideWaitingView;
@end
