//
//  CrashHopperLog.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/14.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "CrashHopperLog.h"
#import "UIDevice+CrashHopper.h"

@implementation CrashHopperLog

+ (instancetype)logWithCallStackSymbols:(NSArray<NSString *> *)symbols exception:(NSException *)exception {
    return [[self alloc] initWithCallStackSymbols:symbols exception:exception];
}

+ (instancetype)logWithDictionary:(NSDictionary *)dict {
    NSArray *symbols = dict[@"symbols"];
    NSException *exception = [NSException exceptionWithName:dict[@"name"] reason:dict[@"reason"] userInfo:nil];
    return [[self alloc] initWithCallStackSymbols:symbols exception:exception];
}

- (instancetype)initWithCallStackSymbols:(NSArray<NSString *> *)symbols exception:(NSException *)exception {
    if (self = [super init]) {
        _name = exception.name;
        _reason = exception.reason ? : @"";
        _callStackSymbols = symbols;
    }
    return self;
}

- (NSString *)date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年M月d日 H点m分ss秒"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)applicationVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [NSString stringWithFormat:@"%@(%@)", infoDict[@"CFBundleShortVersionString"], infoDict[@"CFBundleVersion"]];
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersionName;
}

- (NSString *)machineModel {
    return [UIDevice currentDevice].machineModelName;
}

- (NSString *)description {
    NSDictionary *dict = @{@"date": self.date,
                           @"name": self.name,
                           @"reason": self.reason,
                           @"appVersion": self.applicationVersion,
                           @"systemVersion": self.systemVersion,
                           @"machineModel": self.machineModel,
                           @"symbols": self.callStackSymbols};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else {
        return @"";
    }
}

- (void)outputToConsole {
    NSLog(@"%@", self.description);
}

@end
