//
//  PNStreamUtils.h
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNStreamUtils : NSObject
+ (NSData *)sendData:(nullable NSData *)data writeFileHandle:(nullable NSFileHandle *) writeFileHandle readFileHandle: (NSFileHandle *)readFileHandle;
@end
