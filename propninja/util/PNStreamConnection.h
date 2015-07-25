//
//  PNStreamConnection.h
//  propninja
//
//  Created by Shun Yu on 12/23/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNStreamConnection : NSObject
@property (strong, nonatomic, readonly) NSInputStream *inputStream;
@property (strong, nonatomic, readonly) NSOutputStream *outputStream;


- (id)initWithUrl:(NSString *)url port:(int)port;

- (void)send:(NSData *)data error:(NSError **)error;
- (NSData *)receive:(NSData *)data error:(NSError **)error;

- (void)close;
@end
