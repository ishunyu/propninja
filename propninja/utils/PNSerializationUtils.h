//
//  PNSerializationUtils.h
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNSerializationUtils : NSObject
+ (NSData *)serialize:(id)object;

+ (NSDictionary *)deserialize:(NSData *)data;
+ (NSArray *)deserializeArray:(NSData *)data;
@end
