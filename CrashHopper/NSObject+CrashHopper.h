//
//  NSObject+CrashHopper.h
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import "CrashHopperLog.h"

#define DEAL_CRASHHOPPERLOG \
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols]; \
    CrashHopperLog *log = [CrashHopperLog logWithCallStackSymbols:callStackSymbolsArr exception:exception]; \
    [[CrashHopper sharedInstance] dealWithLog:log];

#define CRASHHOPPER_OPENING [CrashHopper sharedInstance].isStart

@interface NSObject (CrashHopper)

+ (BOOL)swizzleInstanceMethod:(nonnull SEL)originalSel with:(nonnull SEL)newSel;

@end
