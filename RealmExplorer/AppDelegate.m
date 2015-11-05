//
//  AppDelegate.m
//  RealmExplorer
//
//  Created by Lincoln Six Echo on 02.11.15.
//  Copyright © 2015 appdoctors UG. All rights reserved.
//

#import "AppDelegate.h"
#import "CaptainViewController.h"
#import "CaptainFormViewController.h"
#import "DatabaseFactory.h"
#import "DatabaseModel.h"
#import "DatabaseErrorViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - launch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // INIT WINDOW
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // INIT REALM DB
    NSException *dbException = [DatabaseFactory databaseSetup];
    if( dbException ) {
        DatabaseErrorViewController *controller = [[DatabaseErrorViewController alloc] initWithNibName:@"DatabaseErrorViewController" bundle:nil];
        controller.dbException = dbException;
        UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = rootController;
    }
    else {
#if kUSE_FX_FORMS
        CaptainFormViewController *controller = [[CaptainFormViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = rootController;
#else
        CaptainViewController *controller = [[CaptainViewController alloc] initWithNibName:@"CaptainViewController" bundle:nil];
        UINavigationController *rootController = [[UINavigationController alloc] initWithRootViewController:controller];
        self.window.rootViewController = rootController;
#endif
    }
    
    [self.window makeKeyAndVisible];
    return YES;
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

@end
