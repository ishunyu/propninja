//
//  PNServiceUtils.m
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
#import "PNServiceUtils.h"

@implementation PNServiceUtils

#pragma mark Server Paths

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

#pragma mark Requests

+ (BOOL)waitForServerReady: (NSFileHandle *)readFileHandle
{
    NSData *data = [PNStreamUtils sendData:nil writeFileHandle:nil readFileHandle:readFileHandle];
    NSDictionary *dict = [PNSerializationUtils deserializeDictionary:data];
    
    return [dict[@"value"] boolValue];
}

+ (NSDictionary *)dictForIndex:(NSArray *)config
{
    return @{ @"type"  : @"index",
              @"value" : config };
}

+ (NSDictionary *)dictForSearch: (NSString *)word
{
    return @{ @"type": @"search",
              @"key" : word };
}

+ (NSDictionary *)dictForSet:(PNProperty *)property
{
    return @{ @"type" : @"set",
              @"file" : property.pFileInfo.absolutePath,
              @"key"  : property.key,
              @"value": property.value };
}

+ (NSDictionary *)dictForStop
{
    return @{ @"type": @"stop" };
}

#pragma mark Processing
+ (NSArray *)constructPropertiesFromSearchResult:(NSArray *)results pFileInfoConfig:(PNPropertyFileInfoConfig *)pFileInfoConfig;
{
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    
    for (NSArray* result in results) {
        [properties addObject:[[PNProperty alloc] initWithPFileInfo:[pFileInfoConfig pFileInfoForPath:result[0]]
                                                                key:result[1]
                                                              value:result[2]]];
    }
    
    return properties;
}
@end
