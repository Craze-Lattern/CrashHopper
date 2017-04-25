//
//  CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/13.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopperFileHandler.h"

void methodSwizzling(void) {
    // Unrecognized selector
    [NSObject swizzleInstanceMethod:@selector(forwardingTargetForSelector:) with:@selector(hopper_forwardingTargetForSelector:)];

    // Array
    [objc_getClass("__NSArray0") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(hopper0_objectAtIndex:)];
    [objc_getClass("__NSArrayI") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(hopperI_objectAtIndex:)];

    // MutableArray
    [objc_getClass("__NSArrayM") swizzleInstanceMethod:@selector(objectAtIndex:) with:@selector(hopperM_objectAtIndex:)];
    [objc_getClass("__NSArrayM") swizzleInstanceMethod:@selector(insertObject:atIndex:) with:@selector(hopper_insertObject:atIndex:)];

    // Dictionary
    [objc_getClass("__NSPlaceholderDictionary") swizzleInstanceMethod:@selector(initWithObjects:forKeys:count:) with:@selector(hopper_initWithObjects:forKeys:count:)];

    // MutableDictionary
    [objc_getClass("__NSDictionaryM") swizzleInstanceMethod:@selector(setObject:forKey:) with:@selector(hopper_setObject:forKey:)];

    // String
    {
        Class c = objc_getClass("__NSCFConstantString");
        [c swizzleInstanceMethod:@selector(substringFromIndex:) with:@selector(hopper_substringFromIndex:)];
        [c swizzleInstanceMethod:@selector(substringToIndex:) with:@selector(hopper_substringToIndex:)];
        [c swizzleInstanceMethod:@selector(substringWithRange:) with:@selector(hopper_substringWithRange:)];
        [c swizzleInstanceMethod:@selector(stringByReplacingOccurrencesOfString:withString:) with:@selector(hopper_stringByReplacingOccurrencesOfString:withString:)];
        [c swizzleInstanceMethod:@selector(stringByReplacingCharactersInRange:withString:) with:@selector(hopper_stringByReplacingCharactersInRange:withString:)];
    }

    //  TaggedPointerString
    {
        Class c = objc_getClass("NSTaggedPointerString");
        [c swizzleInstanceMethod:@selector(substringFromIndex:) with:@selector(hopper_taggedPointerSubstringFromIndex:)];
        [c swizzleInstanceMethod:@selector(substringToIndex:) with:@selector(hopper_taggedPointerSubstringToIndex:)];
        [c swizzleInstanceMethod:@selector(substringWithRange:) with:@selector(hopper_taggedPointerSubstringWithRange:)];
    }

    // MutableString
    {
        Class c = objc_getClass("__NSCFString");
        [c swizzleInstanceMethod:@selector(replaceCharactersInRange:withString:) with:@selector(hopper_replaceCharactersInRange:withString:)];
        [c swizzleInstanceMethod:@selector(insertString:atIndex:) with:@selector(hopper_insertString:atIndex:)];
        [c swizzleInstanceMethod:@selector(deleteCharactersInRange:) with:@selector(hopper_deleteCharactersInRange:)];
    }
    // AttributedString
    {
        Class c = objc_getClass("NSConcreteAttributedString");
        [c swizzleInstanceMethod:@selector(attributesAtIndex:effectiveRange:) with:@selector(hopper_attributesAtIndex:effectiveRange:)];
        [c swizzleInstanceMethod:@selector(attributedSubstringFromRange:) with:@selector(hopper_attributedSubstringFromRange:)];
    }
    // MutableAttributedString
    {
        Class c = objc_getClass("NSConcreteMutableAttributedString");
        [c swizzleInstanceMethod:@selector(replaceCharactersInRange:withString:) with:@selector(hopper_replaceCharactersInRange:withString:)];
        [c swizzleInstanceMethod:@selector(setAttributes:range:) with:@selector(hopper_setAttributes:range:)];
        [c swizzleInstanceMethod:@selector(addAttribute:value:range:) with:@selector(hopper_addAttribute:value:range:)];
        [c swizzleInstanceMethod:@selector(addAttributes:range:) with:@selector(hopper_addAttributes:range:)];
        [c swizzleInstanceMethod:@selector(removeAttribute:range:) with:@selector(hopper_removeAttribute:range:)];
        [c swizzleInstanceMethod:@selector(replaceCharactersInRange:withAttributedString:) with:@selector(hopper_replaceCharactersInRange:withAttributedString:)];
        [c swizzleInstanceMethod:@selector(insertAttributedString:atIndex:) with:@selector(hopper_insertAttributedString:atIndex:)];
        [c swizzleInstanceMethod:@selector(deleteCharactersInRange:) with:@selector(hopper_deleteCharactersInRange:)];
    }
}

@implementation CrashHopper

+ (instancetype)sharedInstance {
    static CrashHopper *hopper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hopper = [CrashHopper new];
    });
    return hopper;
}

- (void)start {
    if (self.isStart) {
        return;
    }
    self.isStart = YES;
    methodSwizzling();
}

- (void)stop {
    if (!self.isStart) {
        return;
    }
    self.isStart = NO;
    methodSwizzling();
}

- (void)dealWithLog:(CrashHopperLog *)log {
    [[CrashHopperFileHandler sharedInstance] saveWithLog:log];
    [log outputToConsole];
}

@end
