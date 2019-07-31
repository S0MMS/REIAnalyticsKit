//
//  SOMMSAppDelegate.m
//  REIAnalyticsKit
//
//  Created by S0MMS on 07/30/2019.
//  Copyright (c) 2019 S0MMS. All rights reserved.
//

#import "SOMMSAppDelegate.h"

@import REIAnalyticsKit;

@implementation SOMMSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *adobeAppId = @"launch-EN1801f26390774bb8bab92a68711cb71c-development";
    [[REIAnalyticsKitHelper shared] configureAdobeAnalytics:adobeAppId];

#if DEBUG || ADHOC
    [[REIAnalyticsKitHelper shared] configureNewRelicAnalytics:@"AA20f451bc102b114645689092c95bb597146165c4"];
#else
    [[REIAnalyticsKitHelper shared] configureNewRelicAnalytics:@"AA358d1d61904acb8dd941d8709246e68917da15ef"];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
