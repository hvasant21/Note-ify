//
//  Singleton.Template.h
//  Notes
//
//  Created by Harini Vasanthakumar on 14/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#pragma mark - Singletons

#define declareSingleton(MyClass) \
+(MyClass*)sharedManager;


#define defineSingleton(MyClass) \
\
+ (MyClass *)sharedManager   \
\
{   \
\
static MyClass *sharedManager = nil;   \
\
static dispatch_once_t onceToken;   \
\
dispatch_once(&onceToken, ^{    \
\
sharedManager = [[MyClass alloc] init];    \
\
}); \
\
return sharedManager; \
}

