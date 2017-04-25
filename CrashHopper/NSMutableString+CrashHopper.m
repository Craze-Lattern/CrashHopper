//
//  NSMutableString+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSMutableString+CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopper.h"

#define HOPPER_SELECTOR(normal, swizzle) \
if (!CRASHHOPPER_OPENING) { \
[self normal]; \
return; \
} \
@try { \
[self swizzle]; \
} @catch (NSException *exception) { \
DEAL_CRASHHOPPERLOG \
}

@implementation NSMutableString (CrashHopper)

- (void)hopper_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    HOPPER_SELECTOR(replaceCharactersInRange:range withString:aString, hopper_replaceCharactersInRange:range withString:aString)
}

- (void)hopper_deleteCharactersInRange:(NSRange)range {
    HOPPER_SELECTOR(deleteCharactersInRange:range, hopper_deleteCharactersInRange:range)
}

- (void)hopper_insertString:(NSString *)aString atIndex:(NSUInteger)loc {
    HOPPER_SELECTOR(insertString:aString atIndex:loc, hopper_insertString:aString atIndex:loc)
}

@end
