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

#pragma mark Utility
+ (void)setObject:(id<NSCoding>)object forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

+ (id)getObjectForKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data)
        return nil;
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSArray *)getArrayForKey:(NSString *)key
{
    id object = [self getObjectForKey:key];
    if (!object)
        return [NSArray array];
    
    return (NSArray *)object;
}

+ (NSArray *)pFileInfos
{
    return [self getArrayForKey:KEY_CONFIG_PROPERTY_FILES];
}

+ (void)savePFileInfosToUserDefaults:(NSArray* )propertyFileInfoArray
{
    [self setObject:propertyFileInfoArray forKey:KEY_CONFIG_PROPERTY_FILES];
}

+ (id)hotKey
{
    return [self getObjectForKey:KEY_CONFIG_HOTKEY];
}

+ (void)setHotKey:(id<NSCoding>)hotKey
{
    [self setObject:hotKey forKey:KEY_CONFIG_HOTKEY];
}
@end
