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
#import "PNPathUtils.h"
#import "PNStreamUtils.h"
#import "PNServiceUtils.h"

@implementation PNServiceUtils

#pragma mark Server Paths
+ (NSDictionary *)environmentForServer;
{
    return @{
             @"PYTHONPATH": [NSString stringWithFormat:@":%@",
                             [PNPathUtils pathForRelativePath:PATH_SCRIPTS]]
             };
}

+ (NSString *)pathForStandardInputOutputServer
{
    return [PNPathUtils pathForResource:PATH_STANDARD_INPUT_OUTPUT_PROPERTIES_SERVER];
}

+ (NSString *)pathForLogFolder
{
    return [PNPathUtils pathForRelativePath:PATH_SERVER_LOG];
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

+ (NSDictionary *)dictForGet:(NSArray *)properties
{
    return @{
             @"type" : @"get",
             @"value" : properties };
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
