//
//  PNPropertyFile.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "NSString+Utilities.h"

#import "PNConfigManager.h"
#import "PNPropertyFileInfoConfig.h"

@interface PNPropertyFileInfoConfig ()
@property (strong, nonatomic, readwrite) NSMutableArray *propertyFileInfoArray;
@property (strong, nonatomic) NSDictionary *map;
@end

@implementation PNPropertyFileInfoConfig

-(id)init
{
    if (self = [super init]) {
        self.propertyFileInfoArray = [NSMutableArray arrayWithArray:[PNConfigManager propertyFileInfoArray]];
        self.map = [self createPathToPropertyFileInfoIndex];
    }
    
    return self;
}

- (NSDictionary *) createPathToPropertyFileInfoIndex
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (PNPropertyFileInfo *propertyFile in self.propertyFileInfoArray)
        dict[propertyFile.absolutePath == nil ? @"" : propertyFile.absolutePath] = propertyFile;
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark Stuff
- (long)count
{
    return self.propertyFileInfoArray.count;
}

- (PNPropertyFileInfo *)propertyFileInfoForPath:(NSString *)path;
{
    return self.map[path];
}

- (NSArray *)paths
{
    NSMutableArray *config = [[NSMutableArray alloc] init];
    
    for (PNPropertyFileInfo *propertyFile in self.propertyFileInfoArray)
        if (propertyFile.enabled && ![NSString isNullOrEmpty:propertyFile.absolutePath])
            [config addObject:propertyFile.absolutePath];
    
    
    return config;
}

- (void)save
{
    [PNConfigManager setPropertyFileInfoArray:[NSArray arrayWithArray:self.propertyFileInfoArray]];
}


- (void)addEmptyPropertyFileInfo
{
    [self setPropertyFileInfo:[[PNPropertyFileInfo alloc] initWithTag:nil path:nil enabled:YES] index:[self count]];
}

#pragma mark Index Based Operations
- (PNPropertyFileInfo *)propertyFileInfoForIndex:(long)index
{
    return [self.propertyFileInfoArray objectAtIndex:index];
}

- (void)setPropertyFileInfo:(PNPropertyFileInfo *)fileInfo index:(long)index
{
    [self.propertyFileInfoArray setObject:fileInfo atIndexedSubscript:index];
}


- (void)removePropertyFileInfoForIndex:(long)index
{
    [self.propertyFileInfoArray removeObjectAtIndex:index];
}
@end
