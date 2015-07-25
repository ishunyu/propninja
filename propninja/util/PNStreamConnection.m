//
//  PNStreamConnection.m
//  propninja
//
//  Created by Shun Yu on 12/23/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNStreamUtils.h"
#import "PNStreamConnection.h"

@interface PNStreamConnection ()
@property (strong, nonatomic) NSString *url;
@property (nonatomic) int port;
@property (strong, nonatomic, readwrite) NSInputStream *inputStream;
@property (strong, nonatomic, readwrite) NSOutputStream *outputStream;

@end

@implementation PNStreamConnection
- (id)initWithUrl:(NSString *)url port:(int)port
{
    self = [super init];
    if (self) {
        self.url = url;
        self.port = port;
        
        [self initializeInputAndOutputStreams];
    }
    
    return self;
}

- (void)initializeInputAndOutputStreams
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.url, self.port, &readStream, &writeStream);
    
    self.inputStream = (__bridge_transfer NSInputStream *)readStream;
    self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)send:(NSData *)data error:(NSError **)error
{
    [PNStreamUtils send:self.outputStream data:data error:error];
}

- (NSData *)receive:(NSData *)data error:(NSError **)error
{
    [PNStreamUtils send:self.outputStream data:data error:error];
    if (error && *error)
        return nil;

    return [PNStreamUtils read:self.inputStream error:error];
}

- (void)close
{
    [self.outputStream close];
    [self.inputStream close];
    
    self.outputStream = nil;
    self.inputStream = nil;
}
@end
