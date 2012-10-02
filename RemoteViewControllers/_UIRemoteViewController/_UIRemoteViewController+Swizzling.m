//
//  _UIRemoteViewController+Swizzling.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController+Swizzling.h"

id (*globalOriginalRequestViewController)(id, SEL, id, id, id);

id SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler(_UIRemoteViewController *_self, SEL _cmd, id arg1, id arg2, id arg3)
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self: %@", _self);
    NSLog(@"arg1: %@ %@", [arg1 class], arg1);
    NSLog(@"arg2: %@ %@", [arg2 class], arg2);
    NSLog(@"arg3: %@ %@", [arg3 class], arg3);
    
    // Call the original implementation of the method
    id returnValue = globalOriginalRequestViewController(_self, _cmd, arg1, arg2, arg3);
    
    NSLog(@"Return Value: %@ %@", [returnValue class], returnValue);
    return returnValue;
}