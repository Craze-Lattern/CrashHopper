//
//  NSDictionary+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/18.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSDictionary+CrashHopper.h"
#import "CrashHopper.h"
#import "NSObject+CrashHopper.h"

@implementation NSDictionary (CrashHopper)

- (instancetype)hopper_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    if (!CRASHHOPPER_OPENING) {
        return [self initWithObjects:objects forKeys:keys count:cnt];
    }
    NSDictionary *obj = nil;
    @try {
        obj = [self hopper_initWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        if (obj) {
            return obj;
        }else {
            id validObjects[cnt];
            id<NSCopying> validKeys[cnt];
            NSUInteger count = 0;
            for (NSUInteger i = 0; i < count ; i++, count++) {
                if (objects[i] && keys[i]) {
                    validObjects[count] = objects[i];
                    validKeys[count] = keys[i];
                }
            }
            return [self hopper_initWithObjects:validObjects forKeys:validKeys count:count];
        }
    }
}

@end
