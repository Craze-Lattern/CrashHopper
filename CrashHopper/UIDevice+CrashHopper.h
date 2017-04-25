//
//  UIDevice+CrashHopper.h
//  CrashHopper
//
//  Created by guoyuan on 2017/4/18.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (CrashHopper)

@property (nonatomic, readonly) NSString *systemVersionName;

@property (nullable, nonatomic, readonly) NSString *machineModelName;

@end
