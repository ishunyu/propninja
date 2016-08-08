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
#import "PNStreamUtils.h"
#import "PNPropertiesServerUtils.h"

@implementation PNPropertiesServerUtils

#pragma mark Lock
+ (NSString *)pathForLock
{
    return [NSString pathWithComponents:@[[[NSBundle mainBundle] resourcePath],
                                          DIR_SCRIPTS,
                                          [NSString stringWithFormat:@"%@.%@", FILE_PROPERTIES_SERVER, FILE_TYPE_LOCK]]];
}

#pragma mark Server Paths
+ (NSString *)pathForServer
{
    return [[NSBundle mainBundle] pathForResource:FILE_PROPERTIES_SERVER
                                           ofType:FILE_TYPE_PYTHON
                                      inDirectory:DIR_SCRIPTS];
}

+ (NSString *)pathForStandardInputOutputServer
{
    return [[NSBundle mainBundle] pathForResource:FILE_STANDARD_INPUT_OUTPUT_PROPERTIES_SERVER
                                           ofType:FILE_TYPE_PYTHON
                                      inDirectory:DIR_SCRIPTS];
}

+ (NSString *)pathForLogFolder
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:DIR_TEMP];
}

+ (NSArray *)arguments:(int)port lockFile:(NSString *)lockFile
{
    return @[[@(port) stringValue], lockFile];
}

#pragma mark Requests

+ (BOOL)waitForServerReady: (NSFileHandle *)readFileHandle
{
    NSData *data = [PNStreamUtils sendData:nil writeFileHandle:nil readFileHandle:readFileHandle];
    NSDictionary *dict = [PNSerializationUtils deserialize:data];
    
    return [dict[@"value"] boolValue];
}

+ (NSDictionary *)dictForIndex:(NSArray *)config
{
    return @{ @"type"  : @"index",
              @"value" : config };
}

+ (NSData *)requestForIndex:(NSArray *)configuration
{
    NSDictionary *request = [PNPropertiesServerUtils dictForIndex:configuration];
    DDLogVerbose(@"requestForIndex: %@", request);    
    return [PNSerializationUtils serialize:request];
}

+ (NSDictionary *)dictForSearch: (NSString *)word
{
    return @{ @"type": @"search",
              @"key" : word };
}

+ (NSData *)requestForSearch:(NSString *)search
{
    NSDictionary *request = @{ @"type": @"search",
                               @"key" : search };
    
    DDLogVerbose(@"requestForSearch: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

+ (NSDictionary *)dictForSet:(PNProperty *)property
{
    return @{ @"type" : @"set",
              @"file" : property.filePath,
              @"key"  : property.key,
              @"value": property.value };
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

+ (NSDictionary *)dictForStop
{
    return @{ @"type": @"stop" };
}

+ (NSData *)requestForStop
{
    NSDictionary *request = @{ @"type": @"stop" };
    
    DDLogVerbose(@"requestForStop: %@", request);
    
    return [PNSerializationUtils serialize:request];
}

#pragma mark Processing
+ (NSArray *)constructPropertiesFromSearchResult:(NSArray *)results
{
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    
    for (NSArray* result in results) {
        [properties addObject:[[PNProperty alloc] initWithFilePath:result[0] key:result[1] value:result[2]]];
    }
    
    return properties;
}
@end
