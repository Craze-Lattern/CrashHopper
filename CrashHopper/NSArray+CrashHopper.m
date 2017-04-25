//
//  NSArray+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSArray+CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

@implementation NSArray (CrashHopper)

- (id)hopper0_objectAtIndex:(NSUInteger)index {
    if (!CRASHHOPPER_OPENING) {
        return [self objectAtIndex:index];
    }
    id obj = nil;
    @try {
        obj = [self hopper0_objectAtIndex:index];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        return obj;
    }
}

- (id)hopperI_objectAtIndex:(NSUInteger)index {
    if (!CRASHHOPPER_OPENING) {
        return [self objectAtIndex:index];
    }
    id obj = nil;
    @try {
        obj = [self hopperI_objectAtIndex:index];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        return obj;
    }
}

@end
