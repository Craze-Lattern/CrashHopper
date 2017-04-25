//
//  CrashHopperFileHandler.h
//  CrashHopper
//
//  Created by guoyuan on 2017/4/18.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CrashHopperLog;

@interface CrashHopperFileHandler : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly, strong) NSArray<NSString *> *crashFileList;

- (void)saveWithLog:(CrashHopperLog *)log;

- (CrashHopperLog *)readCrashDetail:(NSString *)path;

- (void)removeCrashDetail:(NSString *)path;

- (void)clear;

@end
