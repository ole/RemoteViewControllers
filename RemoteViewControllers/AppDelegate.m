//
//  AppDelegate.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import "_UIRemoteViewController+Swizzling.h"

@implementation AppDelegate

+ (void)load
{
    // Method swizzling
    // See http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
    // We only do this if the _UIRemoteViewController class is available (iOS 6.0+)
    Class UIRemoteViewControllerClass = NSClassFromString(@"_UIRemoteViewController");
    if (UIRemoteViewControllerClass) {
        SEL originalSelector = @selector(requestViewController:fromServiceWithBundleIdentifier:connectionHandler:);
        Method originalMethod = class_getClassMethod(UIRemoteViewControllerClass, originalSelector);
        globalOriginalRequestViewController = (void *)method_getImplementation(originalMethod);
        
        Class UIRemoteViewControllerMetaClass = objc_getMetaClass("_UIRemoteViewController");
        if (!class_addMethod(UIRemoteViewControllerMetaClass, originalSelector, (IMP)SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler, method_getTypeEncoding(originalMethod))) {
            method_setImplementation(originalMethod, (IMP)SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
