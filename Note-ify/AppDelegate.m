//
//  AppDelegate.m
//  Notes
//
//  Created by Harini Vasanthakumar on 13/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import "AppDelegate.h"
#import "DropBoxSessionManager.h"
#import <MagicalRecord/MagicalRecord.h>

#define NAVBAR_COLOR [UIColor colorWithRed:255.0/255.0f green:196.0/255.0f blue:37.0/255.0f alpha:1.0]
#define TITLE_COLOR [UIColor colorWithRed:45.0/255.0f green:45.0/255.0f blue:45.0/255.0f alpha:1.0]
#define NAV_BAR_TITLE [UIFont fontWithName:@"Chalkboard SE" size:19.0f]
@interface AppDelegate ()

@end

static NSString * const kNotesStoreName = @"Note_ify.sqlite";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setNavigationbarAppearance];
    [DropBoxSessionManager sharedManager];
    [self initializeCoreData];
    
    // Add the navigation controller's view to the window and display.
    
    return YES;
}

- (void) setNavigationbarAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBarTintColor:NAVBAR_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: TITLE_COLOR,
                                                            NSFontAttributeName: NAV_BAR_TITLE
                                                            }];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:@{
                              NSForegroundColorAttributeName:[UIColor darkGrayColor],
                            NSFontAttributeName:NAV_BAR_TITLE
                            }forState:UIControlStateNormal];
    
}

//Set up core data stack
- (void)initializeCoreData
{
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:kNotesStoreName];
    

}

- (void) copyDefaultStoreIfNecessary;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kNotesStoreName];
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]])
    {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kNotesStoreName stringByDeletingPathExtension] ofType:[kNotesStoreName pathExtension]];
        
        if (defaultStorePath)
        {
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default notes store");
            }
        }
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL didOpenUrl = [[DropBoxSessionManager sharedManager] checkOpenURL:url];
    return didOpenUrl;
}










@end
