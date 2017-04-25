//
//  NSObject+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

@implementation NSObject (CrashHopper)

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method oldForwardMethod = class_getInstanceMethod(self, originalSel);
    Method newForwardMethod = class_getInstanceMethod(self, newSel);

    if (!oldForwardMethod || !newForwardMethod) return NO;

    BOOL didAddNewForward = class_addMethod(self, originalSel, method_getImplementation(newForwardMethod), method_getTypeEncoding(newForwardMethod));

    if (didAddNewForward) {
        class_replaceMethod(self, newSel, method_getImplementation(oldForwardMethod), method_getTypeEncoding(oldForwardMethod));
    }else {
        method_exchangeImplementations(oldForwardMethod, newForwardMethod);
    }
    return YES;
}

#pragma mark - Unrecognized selector crash
- (id)hopper_forwardingTargetForSelector:(SEL)aSelector {
    if (!CRASHHOPPER_OPENING) {
        return [self forwardingTargetForSelector:aSelector];
    }

    id obj = [self hopper_forwardingTargetForSelector:aSelector];
    if (obj || ![self canForwardContinue] || [NSStringFromClass(self.class) hasPrefix:@"_"]) {
        return obj;
    }

    NSString *className = @"HopperClass";

    if ([self isKindOfClass:NSClassFromString(className)]) {
        return [NSNull null];
    }

    Class newClass = NSClassFromString(className);
    if (!newClass) {
        newClass = objc_allocateClassPair(NSObject.class, [className cStringUsingEncoding:NSUTF8StringEncoding], 0);
        objc_registerClassPair(newClass);
    }

    NSString *selString = NSStringFromSelector(aSelector);
    if (![self isSelctorAdded:selString inClass:newClass]) {
        NSString *className = NSStringFromClass(self.class);
        IMP imp = imp_implementationWithBlock(^(){
            NSException *exception = [NSException exceptionWithName:@"Unrecognized selector" reason:[NSString stringWithFormat:@"-[%@ %@]", className, selString] userInfo:nil];
            DEAL_CRASHHOPPERLOG
        });
        class_addMethod(newClass, aSelector, imp, selString.UTF8String);
    }

    return [newClass new];
}

- (NSArray *)forwardIgnoreClasses {
    return @[@"_NSXPCDistantObject", @"_UIAppearance", @"_WebSafeForwarder", @"_UIWebViewScrollViewDelegateForwarder", @"UIKeyboardPreferencesController", @"UITextInputController", @"UIKeyboardInputManagerMux", @"UIKeyboardInputManagerClient", @"UIWebBrowserView", @"UIThreadSafeNode"];
}

- (BOOL)canForwardContinue {
    __block BOOL canContinue = YES;
    [[self forwardIgnoreClasses] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isKindOfClass:NSClassFromString(obj)]) {
            canContinue = NO;
        }
    }];
    return canContinue;
}

- (BOOL)isSelctorAdded:(NSString *)selString inClass:(Class)class {
    BOOL isAdded = NO;
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        if ([selString isEqualToString:NSStringFromSelector(sel)]) {
            isAdded = YES;
        }
    }
    free(methods);
    return isAdded;
}

@end
