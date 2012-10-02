//
//  MethodArgument.h
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MethodArgument : NSObject

- (id)initWithArgumentType:(const char *)type;
- (NSMutableData *)bufferForContents;

@property (assign, readonly) const char *type;
@property (assign, readonly) size_t size;

@end
