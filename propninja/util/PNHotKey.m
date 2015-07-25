//
//  PNHotKey.m
//  propninja
//
//  Created by Shun Yu on 2/27/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "PNHotKey.h"

@interface PNHotKey()
@property (nonatomic, readwrite) NSUInteger modifierFlags;
@property (nonatomic, readwrite) unsigned short keyCode;
@end

@implementation PNHotKey

- (id)initWithModifierFlags:(NSUInteger)modiferFlags keyCode:(unsigned short)keyCode
{
    if (self = [super init])
    {
        self.modifierFlags = modiferFlags;
        self.keyCode = keyCode;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:self.modifierFlags] forKey:KEY_PROPERTY_MODIFIER_FLAGS];
    [aCoder encodeObject:[NSNumber numberWithUnsignedShort:self.keyCode] forKey:KEY_PROPERTY_KEY_CODE];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSNumber *modifierFlagsNumber = [aDecoder decodeObjectForKey:KEY_PROPERTY_MODIFIER_FLAGS];
    NSNumber *keyCodeNumber = [aDecoder decodeObjectForKey:KEY_PROPERTY_KEY_CODE];
    
    return [[PNHotKey alloc] initWithModifierFlags:[modifierFlagsNumber unsignedIntegerValue]
                                           keyCode:[keyCodeNumber unsignedShortValue]];
}
@end
