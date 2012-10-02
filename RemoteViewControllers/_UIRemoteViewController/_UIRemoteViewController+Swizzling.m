//
//  _UIRemoteViewController+Swizzling.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController+Swizzling.h"
#import "JRSwizzle.h"

@implementation _UIRemoteViewController (Swizzling)

+ (void)load
{
    SEL original = @selector(requestViewController:fromServiceWithBundleIdentifier:connectionHandler:);
    SEL swizzled = @selector(swizzled_requestViewController:fromServiceWithBundleIdentifier:connectionHandler:);
    
    NSError *error = nil;
    BOOL result = [self jr_swizzleClassMethod:original withClassMethod:swizzled error:&error];
    if (result) {
        NSLog(@"Successfully swizzled %@", NSStringFromSelector(original));
    } else {
        NSLog(@"Error swizzling %@: %@", NSStringFromSelector(original), error);
    }
}

+ (id)swizzled_requestViewController:(id)arg1 fromServiceWithBundleIdentifier:(id)arg2 connectionHandler:(id)arg3
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"arg1: %@ %@", [arg1 class], arg1);
    NSLog(@"arg2: %@ %@", [arg2 class], arg2);
    NSLog(@"arg3: %@ %@", [arg3 class], arg3);
    
    // Call the original implementation of the method
    id returnValue = [self swizzled_requestViewController:arg1 fromServiceWithBundleIdentifier:arg2 connectionHandler:arg3];
    
    NSLog(@"Return Value: %@ %@", [returnValue class], returnValue);
    return returnValue;
}

@end
