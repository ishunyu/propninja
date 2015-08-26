//
//  PNPropertiesServerUtils.h
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNProperty.h"

@interface PNPropertiesServerUtils : NSObject
+ (NSString *)pathForLock;

+ (NSArray *)arguments:(int)port lockFile:(NSString *)lockFile;
+ (NSString *)pathForServer;

+ (NSData *)requestForIndex:(NSArray *)configuration;
+ (NSData *)requestForSearch:(NSString *)search;
+ (NSData *)requestForSet:(PNProperty *)property;
+ (NSData *)requestForStatus;
+ (NSData *)requestForStop;
@end
