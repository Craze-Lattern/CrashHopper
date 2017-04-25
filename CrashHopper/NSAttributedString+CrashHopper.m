//
//  NSAttributedString+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/17.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSAttributedString+CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

@implementation NSAttributedString (CrashHopper)

- (NSDictionary<NSString *,id> *)hopper_attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    if (!CRASHHOPPER_OPENING) {
        return [self attributesAtIndex:location effectiveRange:range];
    }
    NSDictionary<NSString *, id> *obj = nil;
    @try {
        obj = [self hopper_attributesAtIndex:location effectiveRange:range];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        return obj;
    }
}

- (NSAttributedString *)hopper_attributedSubstringFromRange:(NSRange)range {
    if (!CRASHHOPPER_OPENING) {
        return [self attributedSubstringFromRange:range];
    }
    NSAttributedString *obj = nil;
    @try {
        obj = [self hopper_attributedSubstringFromRange:range];
    } @catch (NSException *exception) {
        DEAL_CRASHHOPPERLOG
    } @finally {
        return obj ? : self.copy;
    }
}

@end
