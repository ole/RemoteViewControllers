#ifdef DEBUG

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

void pspdf_swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

BOOL PSPDFIsVisibleView(UIView *view);
BOOL PSPDFIsVisibleView(UIView *view) {
    BOOL isViewHidden = view.isHidden || view.alpha == 0 || CGRectIsEmpty(view.frame);
    return !view || (PSPDFIsVisibleView(view.superview) && !isViewHidden);
}

// Following code patches UIView's description to show the classname of an an view controller, if one is attached.
// Will only get compiled for debugging. Use 'po [[UIWindow keyWindow] recursiveDescription]' to invoke.
__attribute__((constructor)) static void PSPDFKitImproveRecursiveDescription(void) {
    @autoreleasepool {
        SEL customViewDescriptionSEL = NSSelectorFromString(@"pspdf_customViewDescription");
        IMP customViewDescriptionIMP = imp_implementationWithBlock(^(id _self) {
            NSMutableString *description = [_self performSelector:customViewDescriptionSEL];
            SEL viewDelegateSEL = NSSelectorFromString([NSString stringWithFormat:@"%@ewDelegate", @"_vi"]); // pr. API
            if ([_self respondsToSelector:viewDelegateSEL]) {
                UIViewController *viewController = [_self performSelector:viewDelegateSEL];
                NSString *viewControllerClassName = NSStringFromClass([viewController class]);
                
                if ([viewControllerClassName length]) {
                    NSString *children = @""; // iterate over childViewControllers
                    
                    if ([viewController respondsToSelector:@selector(childViewControllers)] && [viewController.childViewControllers count]) {
                        NSString *origDescription = description;
                        description = [NSMutableString stringWithFormat:@"%d child[", [viewController.childViewControllers count]];
                        for (UIViewController *childViewController in viewController.childViewControllers) {
                            [description appendFormat:@"%@:%p ", NSStringFromClass([childViewController class]), childViewController];
                        }
                        [description appendFormat:@"] %@", origDescription];
                    }
                    
                    // check if the frame of a childViewController is bigger than the one of a parentViewController. (usually this is a bug)
                    NSString *warnString = @"";
                    if (viewController && viewController.parentViewController && [viewController isViewLoaded] && [viewController.parentViewController isViewLoaded]) {
                        CGRect parentRect = viewController.parentViewController.view.bounds;
                        CGRect childRect = viewController.view.frame;
                        
                        if (parentRect.size.width < childRect.origin.x + childRect.size.width ||
                            parentRect.size.height < childRect.origin.y + childRect.size.height) {
                            warnString = @"* OVERLAP! ";
                        }else if(CGRectIsEmpty(childRect)) {
                            warnString = @"* ZERORECT! " ;
                        }
                    }
                    description = [NSMutableString stringWithFormat:@"%@'%@:%p'%@ %@", warnString, viewControllerClassName, viewController, children, description];
                }
            }
            
            // add marker if view is hidden.
            if (!PSPDFIsVisibleView(_self)) {
                description = [NSMutableString stringWithFormat:@"XX (%@)", description];
            }
            
            return description;
        });
        class_addMethod([UIView class], customViewDescriptionSEL, customViewDescriptionIMP, "@@:");
        pspdf_swizzle([UIView class], @selector(description), customViewDescriptionSEL);
    }
}
#endif