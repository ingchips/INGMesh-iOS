//
//  AppDelegate.m
//  Pandro
//
//  Created by chun on 2018/12/11.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
//#import "MeshPlaceListViewController.h"
#import "MeshPlaceDatabase.h"
#import "LampDeviceSetViewController.h"
#import "INGPortalViewController.h"
#import "LampDeviceAddViewController.h"
#import "LampMeshViewController.h"
#import "LampGroupSetViewController.h"
#import "PandroBlueToothMeshMgrOC.h"
#import "PandroBlueToothManager.h"



@interface AppDelegate ()

@end

/*
 * device list
 * detced device list
 * setting device
 * color select
 */
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [PandroBlueToothMeshMgrOC shareInstance];
//    [[PandroBlueToothManager shareInstance] scanBlueTooth];
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.window = [[UIWindow alloc] initWithFrame:rect];
    
    [[MeshPlaceDatabase shareInstance] refreshDatabase];
    
    
    FirstViewController *firstVC = [[FirstViewController alloc] init];
//    LampPortalViewController *firstVC = [[LampPortalViewController alloc] init];
    
//    LampMeshViewController *firstVC = [[LampMeshViewController alloc] init];

    firstVC = [[INGPortalViewController alloc] init];
//
//    firstVC = [[LampDeviceSetViewController alloc] init];
//    NSMutableDictionary *dictItem = [[NSMutableDictionary alloc] init];
//    [dictItem setValue:@"1551335380973" forKey:@"placeId"];
//    [dictItem setValue:@"33" forKey:@"deviceId"];
//    [dictItem setValue:@"1551787022030" forKey:@"areaId"];
//    firstVC.pageParams = dictItem;
//    firstVC.pageCommand = @"init";

    
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    self.window.rootViewController = navCon;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
