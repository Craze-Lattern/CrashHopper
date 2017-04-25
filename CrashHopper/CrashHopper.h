//
//  CrashHopper.h
//  CrashHopper
//
//  Created by guoyuan on 2017/4/13.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrashHopperLog;

@interface CrashHopper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isStart;

- (void)start;

- (void)stop;

- (void)dealWithLog:(CrashHopperLog *)log;

@end
