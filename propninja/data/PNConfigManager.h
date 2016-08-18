//
//  PNConfigManager.h
//  propninja
//
//  Created by Shun Yu on 2/27/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNConfigManager : NSObject
+ (NSArray *)pFileInfos;
+ (void)savePFileInfosToUserDefaults:(NSArray* )propertyFileInfoArray;
+ (id)hotKey;
+ (void)setHotKey:(id)hotKey;
@end
