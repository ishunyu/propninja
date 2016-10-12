//
//  PNConfigManager.h
//  propninja
//
//  Created by Shun Yu on 2/27/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyUsageMetrics.h"

@interface PNConfigManager : NSObject
#pragma mark Properties Files Infos
+ (NSArray *)pFileInfos;
+ (void)savePFileInfosToUserDefaults:(NSArray* )propertyFileInfoArray;

#pragma mark Property Usage
+ (PNPropertyUsageMetrics *) propertyUsage;
+ (void)save:(PNPropertyUsageMetrics *) propertyUsage;

#pragma mark Hotkeys
+ (id)hotKey;
+ (void)setHotKey:(id)hotKey;
@end
