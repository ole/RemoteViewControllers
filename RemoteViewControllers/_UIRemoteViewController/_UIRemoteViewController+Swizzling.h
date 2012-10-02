//
//  _UIRemoteViewController+Swizzling.h
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController.h"

// Global function pointer to receive implementation of the method we want to swizzle
extern id (*globalOriginalRequestViewController)(id, SEL, id, id, id);

// New implementation of the swizzled method
id SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler(_UIRemoteViewController *, SEL, id, id, id);