//
//  PNPropertyFile.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "PNLoggerUtils.h"
#import "NSString+Utilities.h"

#import "PNConfigManager.h"
#import "PNPropertyFileInfoConfig.h"

@interface PNPropertyFileInfoConfig ()
@property (strong, nonatomic, readwrite) NSMutableArray *pFileInfos;
@property (strong, nonatomic) NSDictionary *absPathToPFileInfos;
@end

@implementation PNPropertyFileInfoConfig

-(id)init
{
    if (self = [super init]) {
        self.pFileInfos = [NSMutableArray arrayWithArray:[PNConfigManager pFileInfos]];
        [self index];
    }
    
    return self;
}

- (void) index
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (PNPropertyFileInfo *propertyFile in self.pFileInfos)
        dict[propertyFile.absolutePath == nil ? @"" : propertyFile.absolutePath] = propertyFile;
    
    self.absPathToPFileInfos =[NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark Stuff
- (long)count
{
    return self.pFileInfos.count;
}

- (PNPropertyFileInfo *)pFileInfoForPath:(NSString *)path;
{
    return self.absPathToPFileInfos[path];
}

- (NSArray *)arrayOfPaths
{
    NSMutableArray *config = [[NSMutableArray alloc] init];
    
    for (PNPropertyFileInfo *propertyFile in self.pFileInfos)
        if (propertyFile.enabled && ![NSString isNullOrEmpty:propertyFile.absolutePath])
            [config addObject:propertyFile.absolutePath];
    
    
    return config;
}

- (void)saveToUserDefaults
{
    [PNConfigManager savePFileInfosToUserDefaults:[NSArray arrayWithArray:self.pFileInfos]];
}


- (void)addEmptyPFileInfo
{
    [self setPFileInfo:[[PNPropertyFileInfo alloc] initWithLabel:nil path:nil enabled:YES] index:[self count]];
}

#pragma mark Index Based Operations
- (PNPropertyFileInfo *)pFileInfoForIndex:(long)index
{
    return [self.pFileInfos objectAtIndex:index];
}

- (void)setPFileInfo:(PNPropertyFileInfo *)fileInfo index:(long)index
{
    [self.pFileInfos setObject:fileInfo atIndexedSubscript:index];
}


- (void)removePFileInfoForIndex:(long)index
{
    [self.pFileInfos removeObjectAtIndex:index];
}
@end
