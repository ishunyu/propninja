//
//  PNPropertyFile.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"
#import "PNPropertyFileInfo.h"

@interface PNPropertyFileInfo ()
@property (strong, nonatomic, readwrite) NSString *label;
@property (strong, nonatomic, readwrite) NSString *path;
@property (strong, nonatomic, readwrite) NSString *absolutePath;
@end

@implementation PNPropertyFileInfo

- (id)initWithLabel:(NSString *)label path:(NSString *)path enabled:(BOOL)enabled
{
    if (self = [super init])
    {
        self.label = label;
        self.path = path;
        self.absolutePath = [path stringByExpandingTildeInPath];
        self.enabled = enabled;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithLabel:[aDecoder decodeObjectForKey:KEY_PROPERTY_TAG]
                        path:[aDecoder decodeObjectForKey:KEY_PROPERTY_PATH]
                     enabled:[aDecoder decodeBoolForKey:KEY_PROPERTY_ENABLED]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.label forKey:KEY_PROPERTY_TAG];
    [aCoder encodeObject:self.path forKey:KEY_PROPERTY_PATH];
    [aCoder encodeBool:self.enabled forKey:KEY_PROPERTY_ENABLED];
}

@end
