//
//  PNProperty.m
//  propninja
//
//  Created by Shun Yu on 1/4/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNProperty.h"

@interface PNProperty ()
@property (strong, nonatomic, readwrite) PNPropertyFileInfo *pFileInfo;
@property (strong, nonatomic, readwrite) NSString *key;
@property (strong, nonatomic, readwrite) NSString *value;
@end

@implementation PNProperty
-(id)initWithPFileInfo:(PNPropertyFileInfo *)pFileInfo key:(NSString *)key value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.pFileInfo = pFileInfo;
        self.key = key;
        self.value = value;
    }
    
    return self;
}

-(id)initWithProperty:(PNProperty *)property value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.pFileInfo = property.pFileInfo;
        self.key = property.key;
        self.value = value;
    }
    
    return self;
}

- (NSString *)description
{
    return [@{@"pFileInfo": self.pFileInfo,
              @"key": self.key,
              @"value": self.value} description];
}
@end
