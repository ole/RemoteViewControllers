# Remote View Controllers in iOS 6

Written by Ole Begemann, September/October 2012.

This is a test app for investigating the new private and undocumented feature of _remote view controllers_ in iOS 6. The app is accompanied by two extensive blog articles on the topic, [part 1](http://oleb.net/blog/2012/10/remote-view-controllers-in-ios-6/) and [part 2](http://oleb.net/blog/2012/10/more-on-remote-view-controllers/). Please read them for further documentation.

## Overview

![test-app-screenshot.png]

The main screen consists of several buttons. Tapping one of them creates one of several of iOS's built-in view controllers and presents it on screen. Examples include the mail or SMS compose view and Twitter/Facebook sharing.

While the UIs for these controllers have mostly not changed in iOS 6, they have changed considerably under the hood. Using the Activity Monitor instrument in Instruments and the log messages in the app, you can see that most of these sharing views now run in separate processes, using XPC for communicating with the host app.

Have a look at the app's code to follow what's going on.

## Remote Web View Controller

The bottom-most button, _Open Remote Web View_, uses the findings made in the two blog articles in an attempt to create an instance of the undocumented `_WebViewController` class and present it on screen. The hope is that this class is the entry point for the creation of a `_UIRemoteWebViewController` and a corresponding XPC service in which the actual web view would run.

The code looks like this:

    - (IBAction)openWebView:(id)sender
    {
        _UIWebViewController *controller = [[_UIWebViewController alloc] init];
        controller.delegate = self;

        NSURL *url = [NSURL URLWithString:@"http://google.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [controller loadRequest:request];
    
        [self presentViewController:controller animated:YES completion:^{
            // Log the view hierarchy here to see what's going on
            //NSLog(@"View hierarchy: %@", [controller.view recursiveDescription]);
        }];
    }

Unfortunately, this does not work, though we seem to be on the right track. The log messages in the swizzled  `+requestViewController:fromServiceWithBundleIdentifier:connectionHandler:` method prove that the method is being called with seemingly the correct arguments:

    self: _UIRemoteWebViewController
    arg1: __NSCFConstantString _UIServiceWebViewController
    arg2: __NSCFConstantString com.apple.WebViewService
    arg3: __NSStackBlock__ <__NSStackBlock__: 0x2fdaa6bc>
    Return Value: _UIAsyncInvocation <_UIAsyncInvocation: 0x1e0376f0>

Sadly, the `connectionHandler` block returns an error rather than a valid `_UIRemoteWebViewController` instance:

    blockArg1: (null) (null)
    blockArg2: NSError Error Domain=XPCObjectsErrorDomain Code=2 "The operation couldn’t be completed. (XPCObjectsErrorDomain error 2.)"
    Failed to get remote view controller with error: Error Domain=XPCObjectsErrorDomain Code=2 "The operation couldn’t be completed. (XPCObjectsErrorDomain error 2.)"
    
I'd love to hear from you if you have any idea what else I could try.