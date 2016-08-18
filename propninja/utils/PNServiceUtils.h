//
//  PNServiceUtils.h
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNProperty.h"
#import "PNPropertyFileInfoConfig.h"

@interface PNServiceUtils : NSObject
+ (NSString *)pathForStandardInputOutputServer;
+ (NSString *)pathForLogFolder;

+ (BOOL)waitForServerReady:(NSFileHandle *)readFileHandle;

+ (NSDictionary *)dictForIndex:(NSArray *)config;
+ (NSDictionary *)dictForSearch:(NSString *)word;
+ (NSDictionary *)dictForSet:(PNProperty *)property;
+ (NSDictionary *)dictForStop;

+ (NSArray *)constructPropertiesFromSearchResult:(NSArray *)results pFileInfoConfig:(PNPropertyFileInfoConfig *)pFileInfoConfig;
@end
