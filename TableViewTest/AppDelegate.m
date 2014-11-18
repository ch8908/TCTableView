//
//  AppDelegate.m
//  TableViewTest
//
//  Created by 李道政 on 2014/10/23.
//  Copyright (c) 2014年 李道政. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CollectedViewController.h"
#import "UIColor+Util.h"

//#import "NavigationController.h"
@interface AppDelegate()

@end

@implementation AppDelegate


- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    MainViewController *mainVC = [[MainViewController alloc] init];
    CollectedViewController *collectedVC = [[CollectedViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *collectedNC = [[UINavigationController alloc] initWithRootViewController:collectedVC];
    NSArray *controllers = @[navigationController, collectedNC];
    tabBarController.viewControllers = controllers;
    UIImage *anImage = [UIImage imageNamed:@"settings_icon.png"];
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *theItem0 = (tabBar.items)[0];
    UITabBarItem *theItem1 = (tabBar.items)[1];
    [theItem0 initWithTitle:@"Tab1" image:anImage tag:0];
//    [theItem0.title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:20]}];
    [theItem1 initWithTitle:@"Tab2" image:anImage tag:0];
//    theItem0.title = @"Tab1";
//    theItem1.title = @"Tab2";
//    theItem0.image = anImage;
//    theItem1.image = anImage;
//    theItem0.badgeValue = @"1";
    [[UITabBar appearance] setTintColor:[UIColor hexARGB:0x3FFF0000]];
    [[UITabBar appearance] setBarTintColor:[UIColor hexARGB:0x33C0C0C0]];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) applicationWillResignActive:(UIApplication *) application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *) application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *) application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *) application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *) application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
