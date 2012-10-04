//
//  LoggerProxy.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "LoggerProxy.h"
#import "NSInvocation+Logging.h"

@implementation LoggerProxy {
    id _forwardingTarget;
}

- (id)initWithForwardingTarget:(id)forwardingTarget
{
    NSAssert(forwardingTarget != nil, @"forwardingTarget must not be nil");
    _forwardingTarget = forwardingTarget;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [_forwardingTarget methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSLog(@"Logger Proxy: [%@ %@]", _forwardingTarget, NSStringFromSelector([invocation selector]));
    NSArray *argumentList = [invocation readableArgumentList];
    if ([argumentList count] > 0) {
        NSLog(@"  called with arguments: %@", argumentList);
    }
    [invocation invokeWithTarget:_forwardingTarget];
    NSLog(@"  return value: %@", [invocation informationOnReturnValue]);
}

@end
