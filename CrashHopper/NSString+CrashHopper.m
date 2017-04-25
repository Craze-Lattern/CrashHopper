//
//  NSString+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSString+CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

#define HOPPER_SELECTOR(normal, swizzle) \
if (!CRASHHOPPER_OPENING) { \
return [self normal]; \
} \
NSString *obj = nil; \
@try { \
    obj = [self swizzle]; \
} @catch (NSException *exception) { \
    DEAL_CRASHHOPPERLOG \
} @finally { \
    return obj ? : self.copy; \
}

@implementation NSString (CrashHopper)

- (NSString *)hopper_substringToIndex:(NSUInteger)to {
    HOPPER_SELECTOR(substringToIndex:to, hopper_substringToIndex:to)
}

- (NSString *)hopper_substringFromIndex:(NSUInteger)from {
    HOPPER_SELECTOR(substringFromIndex:from, hopper_substringFromIndex:from)
}

- (NSString *)hopper_substringWithRange:(NSRange)range {
    HOPPER_SELECTOR(substringWithRange:range, hopper_substringWithRange:range)
}

- (NSString *)hopper_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    HOPPER_SELECTOR(stringByReplacingCharactersInRange:range withString:replacement, hopper_stringByReplacingCharactersInRange:range withString:replacement)
}

- (NSString *)hopper_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    HOPPER_SELECTOR(stringByReplacingOccurrencesOfString:target withString:replacement, hopper_stringByReplacingOccurrencesOfString:target withString:replacement)
}

- (NSString *)hopper_taggedPointerSubstringToIndex:(NSUInteger)to {
    HOPPER_SELECTOR(substringToIndex:to, hopper_taggedPointerSubstringToIndex:to)
}

- (NSString *)hopper_taggedPointerSubstringFromIndex:(NSUInteger)from {
    HOPPER_SELECTOR(substringFromIndex:from, hopper_taggedPointerSubstringFromIndex:from)
}

- (NSString *)hopper_taggedPointerSubstringWithRange:(NSRange)range {
    HOPPER_SELECTOR(substringWithRange:range, hopper_taggedPointerSubstringWithRange:range)
}

@end
