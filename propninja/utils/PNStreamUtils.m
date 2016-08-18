//
//  PNStreamUtils.m
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNConstants.h"
#import "PNLoggerUtils.h"
#import "PNStreamUtils.h"

@implementation PNStreamUtils

#pragma mark NSFileHandle
+ (NSData *)sendData:(nullable NSData *)data writeFileHandle:(nullable NSFileHandle *)writeFileHandle readFileHandle:(NSFileHandle *)readFileHandle
{
    if (data != nil) {
        [writeFileHandle writeData:[PNStreamUtils appendNewline:data]];
    }
    
    NSMutableData *mData = [[NSMutableData alloc] initWithCapacity:1024];
    while (true) {
        NSData *_rData = [readFileHandle availableData];
        [mData appendData:_rData];
        
        NSRange range = [_rData rangeOfData:[PNStreamUtils newlineData]
                                  options:NSDataSearchBackwards | NSDataSearchAnchored
                                    range:NSMakeRange(0, [_rData length])];
        
        if (range.location != NSNotFound) {
            return [NSData dataWithData:mData];
        }
    }
}

+ (NSData *)appendNewline: (NSData *)data
{
    NSMutableData *mData = [NSMutableData dataWithCapacity:[data length] + 1];
    [mData appendData:data];
    [mData appendData:[PNStreamUtils newlineData]];
    return [NSData dataWithData:mData];
}

+ (NSData *)newlineData
{
    return [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
}
@end
