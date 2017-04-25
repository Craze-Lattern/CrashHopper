//
//  NSMutableAttributedString+CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/17.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "NSMutableAttributedString+CrashHopper.h"
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

@implementation NSMutableAttributedString (CrashHopper)

- (void)hopper_replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    HOPPER_SELECTOR(replaceCharactersInRange:range withString:str, hopper_replaceCharactersInRange:range withString:str)
}

- (void)hopper_setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    HOPPER_SELECTOR(setAttributes:attrs range:range, hopper_setAttributes:attrs range:range)
}

- (void)hopper_addAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    HOPPER_SELECTOR(addAttribute:name value:value range:range, hopper_addAttribute:name value:value range:range)
}

- (void)hopper_addAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    HOPPER_SELECTOR(addAttributes:attrs range:range, hopper_addAttributes:attrs range:range)
}

- (void)hopper_removeAttribute:(NSString *)name range:(NSRange)range {
    HOPPER_SELECTOR(removeAttribute:name range:range, hopper_removeAttribute:name range:range)
}

- (void)hopper_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString {
    HOPPER_SELECTOR(replaceCharactersInRange:range withAttributedString:attrString, hopper_replaceCharactersInRange:range withAttributedString:attrString)
}

- (void)hopper_insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc {
    HOPPER_SELECTOR(insertAttributedString:attrString atIndex:loc, hopper_insertAttributedString:attrString atIndex:loc)
}

- (void)hopper_deleteCharactersInRange:(NSRange)range {
    HOPPER_SELECTOR(deleteCharactersInRange:range, hopper_deleteCharactersInRange:range)
}

@end
