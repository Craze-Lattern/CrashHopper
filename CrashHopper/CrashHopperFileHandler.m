//
//  CrashHopperFileHandler.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/18.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "CrashHopperFileHandler.h"
#import "CrashHopperLog.h"

#define DEFAULT_FOLDERNAME @"com.log.crashhopper"

@interface CrashHopperFileHandler ()

@property (nonatomic, readonly, strong) NSURL *folderURL;

@end

@implementation CrashHopperFileHandler

+ (instancetype)sharedInstance {
    static CrashHopperFileHandler *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] initWithCacheFolderName:DEFAULT_FOLDERNAME];
    });
    return cache;
}

- (instancetype)initWithCacheFolderName:(NSString *)folderName {
    if (self = [super init]) {
        NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        _folderURL = [documentURL URLByAppendingPathComponent:folderName isDirectory:YES];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_folderURL.absoluteString isDirectory:YES]) {
            [[NSFileManager defaultManager] createDirectoryAtURL:_folderURL withIntermediateDirectories:true attributes:nil error:nil];
        }
    }
    return self;
}

- (void)saveWithLog:(CrashHopperLog *)log {
    NSString *fileName = [NSString stringWithFormat:@"%@.log", log.date];
    NSURL *filePathURL = [self.folderURL URLByAppendingPathComponent:fileName];
    [log.description writeToURL:filePathURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSArray<NSString *> *)crashFileList {
    return [self filesByModDate];
}

- (NSArray *)filesByModDate {
    NSError *error = nil;
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:self.folderURL.absoluteString error:&error];
    if (!error) {
        NSMutableDictionary *filesAndProperties = [NSMutableDictionary dictionaryWithCapacity:files.count];
        for(NSString *path in files) {
            NSDictionary *properties = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:[self.folderURL.absoluteString stringByAppendingPathComponent:path]
                                        error:&error];
            NSDate *modDate = [properties objectForKey:NSFileModificationDate];

            if(!error) {
                [filesAndProperties setValue:modDate forKey:path];
            }
        }
        return [filesAndProperties keysSortedByValueUsingSelector:@selector(compare:)];
    }
    return [NSArray array];
}

- (CrashHopperLog *)readCrashDetail:(NSString *)path {
    NSError *err = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return [CrashHopperLog logWithDictionary:dict];
}

- (void)removeCrashDetail:(NSString *)path {
    NSURL *fileURL = [self.folderURL URLByAppendingPathComponent:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileURL.absoluteString]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
}

- (void)clear {
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.folderURL.absoluteString]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtURL:self.folderURL error:nil];
}

@end
