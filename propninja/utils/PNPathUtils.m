//
//  PNPathUtils.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "NSString+Utilities.h"

#import "PNPathUtils.h"

@implementation PNPathUtils
+ (NSString *)autocomplete:(NSString *)path
{
    if (!path)
        return @"";
    
    path = [path strip];
    
    if ([path isEmpty])
        return @"";
    
    NSString *fullPath = [path stringByExpandingTildeInPath];
    fullPath = [path lastCharacter] == '/' ? [fullPath stringByAppendingString:@"/"] : fullPath;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
        return path;
    
    NSString *fullDir = [fullPath lastCharacter] == '/' ? fullPath : [fullPath stringByDeletingLastPathComponent];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullDir])
        return path;
    
    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullDir error:&error];
    
    if (error)
        return path;
    
    NSString *lastComponent = [fullPath lastPathComponent];
    
    for (NSString *item in contents)
    {
        if ([item hasPrefix:lastComponent])
        {
            NSString *fullAutocomplete = [fullDir stringByAppendingPathComponent:item];            
            return [fullPath isEqualToString:path] ? fullAutocomplete : [fullAutocomplete stringByAbbreviatingWithTildeInPath];
        }
    }
    
    return path;
}
@end
