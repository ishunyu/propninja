//
//  PNSerializationUtils.m
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNSerializationUtils.h"

@implementation PNSerializationUtils
+ (NSData *)serialize:(id)object
{
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
}

+ (NSDictionary *)deserializeDictionary:(NSData *)data
{
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
@end
