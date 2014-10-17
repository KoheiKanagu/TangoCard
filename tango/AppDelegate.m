//
//  AppDelegate.m
//  tango
//
//  Created by Kohei on 2014/10/07.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [CSVLoader loadCSVfromURL:url];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager removeItemAtURL:url
                               error:&error]){
        NSLog(@"%@", error.localizedDescription);
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UINavigationController *naviCtrl = (UINavigationController *)window.rootViewController;
    [naviCtrl popToRootViewControllerAnimated:YES];

    MainTableViewController *mainTableView = (MainTableViewController *)naviCtrl.topViewController;
    [mainTableView loadItems];
    [mainTableView.tableView reloadData];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud synchronize];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
