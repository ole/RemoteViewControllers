//
//  _UIRemoteViewController+Swizzling.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController+Swizzling.h"
#import "_UIAsyncInvocation.h"

id (*globalOriginalRequestViewController)(id, SEL, id, id, id);

_UIAsyncInvocation *SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler(_UIRemoteViewController *_self, SEL _cmd, NSString *viewControllerName, NSString *serviceBundleID, id connectionHandlerBlock)
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self: %@", _self);
    NSLog(@"arg1: %@ %@", [viewControllerName class], viewControllerName);
    NSLog(@"arg2: %@ %@", [serviceBundleID class], serviceBundleID);
    NSLog(@"arg3: %@ %@", [connectionHandlerBlock class], connectionHandlerBlock);
    
    // Call the original implementation of the method
    _UIAsyncInvocation *returnValue = globalOriginalRequestViewController(_self, _cmd, viewControllerName, serviceBundleID, connectionHandlerBlock);
    
    NSLog(@"Return Value: %@ %@", [returnValue class], returnValue);
    return returnValue;
}