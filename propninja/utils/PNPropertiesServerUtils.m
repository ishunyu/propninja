//
//  PNPropertiesServerUtils.m
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"

#import "PNConstants.h"
#import "NSString+Utilities.h"
#import "PNSerializationUtils.h"
#import "PNPropertiesServerUtils.h"

@implementation PNPropertiesServerUtils

#pragma mark lock
+ (NSString *)pathForLock
{
    return [NSString pathWithComponents:@[[[NSBundle mainBundle] resourcePath],
                                          DIR_SCRIPTS,
                                          [NSString stringWithFormat:@"%@.%@", FILE_PROPERTIES_SERVER, FILE_TYPE_LOCK]]];
}

#pragma mark Exec
+ (NSString *)pathForServer
{
    return [[NSBundle mainBundle] pathForResource:FILE_PROPERTIES_SERVER
                                           ofType:FILE_TYPE_PYTHON
                                      inDirectory:DIR_SCRIPTS];
}

+ (NSArray *)arguments:(int)port lockFile:(NSString *)lockFile
{
    return @[[@(port) stringValue], lockFile];
}

#pragma mark Requests

+ (NSData *)requestForIndex:(NSArray *)configuration
{
    NSDictionary *request = @{ @"type"  : @"index",
                               @"value" : configuration };
    
    DDLogVerbose(@"requestForIndex: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForSearch:(NSString *)search
{
    NSDictionary *request = @{ @"type": @"search",
                               @"key" : search };
    
    DDLogVerbose(@"requestForSearch: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForSet:(PNProperty *)property
{
    NSDictionary *request = @{ @"type" : @"set",
                               @"file" : property.filePath,
                               @"key"  : property.key,
                               @"value": property.value };
    
    DDLogVerbose(@"requestForSet: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForStatus
{
    NSDictionary *request = @{ @"type": @"status" };
    
    DDLogVerbose(@"requestForStatus: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForStop
{
    NSDictionary *request = @{ @"type": @"stop" };
    
    DDLogVerbose(@"requestForStop: %@", request);
    
    return [PNSerializationUtils serialize:request];
}
@end
