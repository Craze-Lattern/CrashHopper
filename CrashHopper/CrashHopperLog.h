//
//  CrashHopperLog.h
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrashHopperLog : NSObject

+ (instancetype)logWithCallStackSymbols:(NSArray<NSString *> *)symbols exception:(NSException *)exception;

+ (instancetype)logWithDictionary:(NSDictionary *)dict;

@property (nonatomic, readonly, copy) NSString *date;

@property (nonatomic, readonly, copy) NSString *name;

@property (nonatomic, readonly, copy) NSString *reason;

@property (nonatomic, readonly, copy) NSString *applicationVersion;

@property (nonatomic, readonly, copy) NSString *systemVersion;

@property (nonatomic, readonly, copy) NSString *machineModel;

@property (nonatomic, readonly, copy) NSArray<NSString *> *callStackSymbols;

- (void)outputToConsole;

@end
