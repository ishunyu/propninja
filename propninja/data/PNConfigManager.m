//
//  PNConfigManager.m
//  propninja
//
//  Created by Shun Yu on 2/27/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "PNConfigManager.h"

@implementation PNConfigManager
#pragma mark Properties Files Infos
+ (NSArray *)pFileInfos
{
    return [self arrayForKey:KEY_CONFIG_PROPERTY_FILES];
}

+ (void)savePFileInfosToUserDefaults:(NSArray* )propertyFileInfoArray
{
    [self setObject:propertyFileInfoArray forKey:KEY_CONFIG_PROPERTY_FILES];
}

#pragma mark Property Usage
+ (PNPropertyUsageMetrics *) propertyUsage
{
    PNPropertyUsageMetrics *usage = [self objectForKey:KEY_CONFIG_PROPERTY_USAGE_METRICS];
    if (usage == nil) {
        usage = [[PNPropertyUsageMetrics alloc] init];
        [PNConfigManager save:usage];
    }
    
    return usage;
}

+ (void)save:(PNPropertyUsageMetrics *) propertyUsage
{
    [self setObject:propertyUsage forKey:KEY_CONFIG_PROPERTY_USAGE_METRICS];
}

#pragma mark Hotkeys
+ (id)hotKey
{
    return [self objectForKey:KEY_CONFIG_HOTKEY];
}

+ (void)setHotKey:(id<NSCoding>)hotKey
{
    [self setObject:hotKey forKey:KEY_CONFIG_HOTKEY];
}

#pragma mark Utility
+ (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

+ (id)objectForKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data)
        return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSArray *)arrayForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    if (!object)
        return [NSArray array];
    
    return (NSArray *)object;
}
@end
