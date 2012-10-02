//
//  _UIRemoteViewController+Swizzling.h
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController.h"

@interface _UIRemoteViewController (Swizzling)

+ (id)swizzled_requestViewController:(id)arg1 fromServiceWithBundleIdentifier:(id)arg2 connectionHandler:(id)arg3;

@end
