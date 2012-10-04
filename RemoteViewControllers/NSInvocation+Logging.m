//
//  NSInvocation+Logging.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "NSInvocation+Logging.h"

@implementation NSInvocation (Logging)

- (NSArray *)readableArgumentList
{
    NSMethodSignature *signature = [self methodSignature];
    NSUInteger numberOfArguments = [signature numberOfArguments];
    NSMutableArray *arguments = [NSMutableArray new];
    for (NSUInteger argumentIndex = 2; argumentIndex < numberOfArguments; argumentIndex++)
    {
        const char *argumentType = [signature getArgumentTypeAtIndex:argumentIndex];
        MethodArgument *argument = [[MethodArgument alloc] initWithArgumentType:argumentType];
        NSMutableData *buffer = [argument bufferForContents];
        [self getArgument:[buffer mutableBytes] atIndex:argumentIndex];
        
        [arguments addObject:argument];
    }
    return arguments;
}

- (MethodArgument *)informationOnReturnValue
{
    NSMethodSignature *signature = [self methodSignature];
    const char *returnType = [signature methodReturnType];
    MethodArgument *returnValue = [[MethodArgument alloc] initWithArgumentType:returnType];
    NSMutableData *buffer = [returnValue bufferForContents];
    if (buffer) {
        [self getReturnValue:[buffer mutableBytes]];
    }
    return returnValue;
}

@end
