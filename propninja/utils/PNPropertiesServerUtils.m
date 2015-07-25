//
//  PNPropertiesServerUtils.m
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"
#import "NSString+Utilities.h"
#import "PNSerializationUtils.h"
#import "PNPropertiesServerUtils.h"

@implementation PNPropertiesServerUtils

#pragma mark Exec
+ (NSString *)pathForServer
{
    return [[NSBundle mainBundle] pathForResource:FILE_PROPERTIES_SERVER
                                           ofType:FILE_TYPE_PYTHON
                                      inDirectory:DIR_SCRIPTS];
}

+ (NSArray *)arguments:(int)port
{
    return @[[@(port) stringValue]];
}

#pragma mark Requests

+ (NSData *)requestForIndex:(NSArray *)configuration
{
    NSDictionary *request = @{ @"type"  : @"index",
                               @"value" : configuration };
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForSearch:(NSString *)search
{
    NSDictionary *request = @{ @"type": @"search",
                               @"key" : search };
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForSet:(PNProperty *)property
{
    NSDictionary *request = @{ @"type" : @"set",
                               @"file" : property.filePath,
                               @"key"  : property.key,
                               @"value": property.value };
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForStatus
{
    NSDictionary *request = @{ @"type": @"status" };
    
    return [PNSerializationUtils serialize:request];
}

+ (NSData *)requestForStop
{
    NSDictionary *request = @{ @"type": @"stop" };
    
    return [PNSerializationUtils serialize:request];
}
@end
