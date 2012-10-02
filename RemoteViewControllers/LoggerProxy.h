//
//  LoggerProxy.h
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggerProxy : NSProxy

- (id)initWithForwardingTarget:(id)forwardingTarget;

@end
