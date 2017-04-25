//
//  NSMutableDictionary+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSMutableDictionary+CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

@implementation NSMutableDictionary (CrashHopper)

- (void)hopper_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!CRASHHOPPER_OPENING) {
        [self setObject:anObject forKey:aKey];
        return;
    }
    @try {
        [self hopper_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    }
}

@end
