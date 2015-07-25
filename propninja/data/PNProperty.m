//
//  PNProperty.m
//  propninja
//
//  Created by Shun Yu on 1/4/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNProperty.h"

@interface PNProperty ()
@property (strong, nonatomic, readwrite) NSString *filePath;
@property (strong, nonatomic, readwrite) NSString *key;
@property (strong, nonatomic, readwrite) NSString *value;
@end

@implementation PNProperty
-(id)initWithFilePath:(NSString *)filePath key:(NSString *)key value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.filePath = filePath;
        self.key = key;
        self.value = value;
    }
    
    return self;
}

-(id)initWithProperty:(PNProperty *)property value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.filePath = property.filePath;
        self.key = property.key;
        self.value = value;
    }
    
    return self;
}
@end
