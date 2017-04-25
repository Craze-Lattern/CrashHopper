//
//  NSMutableArray+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/18.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSMutableArray+CrashHopper.h"
#import "CrashHopper.h"
#import "NSObject+CrashHopper.h"

@implementation NSMutableArray (CrashHopper)

- (id)hopperM_objectAtIndex:(NSUInteger)index {
    if (!CRASHHOPPER_OPENING) {
        return [self objectAtIndex:index];
    }
    id obj = nil;
    @try {
        obj = [self hopperM_objectAtIndex:index];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        return obj;
    }
}

- (void)hopper_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!CRASHHOPPER_OPENING) {
        [self insertObject:anObject atIndex:index];
        return;
    }
    @try {
        [self hopper_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    }
}

@end
