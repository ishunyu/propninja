//
//  PNStreamUtils.m
//  propninja
//
//  Created by Shun Yu on 1/3/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>

#import "PNConstants.h"
#import "PNLoggerUtils.h"
#import "PNNumericUtils.h"
#import "PNStreamUtils.h"

@implementation PNStreamUtils
+ (void)setSocketAddress:(struct sockaddr_in *)socketAddress port:(int)port
{
    bzero((char *) &(*socketAddress), sizeof(*socketAddress));
    socketAddress->sin_family = AF_INET;
    socketAddress->sin_addr.s_addr = INADDR_ANY;
    socketAddress->sin_port = htons(port);
}

+ (BOOL)bindSocket:(struct sockaddr_in)socketAddress socket:(int)socket
{
    return bind(socket, (struct sockaddr *) &socketAddress, sizeof(socketAddress)) == 0;
}

+ (BOOL)test:(int)port
{
    int socketfd;
    struct sockaddr_in socketAddress;
    
    socketfd = socket(AF_INET, SOCK_STREAM, 0);
    if (socketfd < 0)
        return NO;
    
    [self setSocketAddress:&socketAddress port:port];
    
    if (![self bindSocket:socketAddress socket:socketfd])
        return NO;

    // Success!
    close(socketfd);
    return YES;
}

+ (int) findOpenPort
{
    int tries = 25;
    while (tries--) {
        int port = [PNNumericUtils randomNumberBetween:10000 max:20000];
        
        if([self test:port]) {
            return port;
        }
    }
    
    return 0;
}

+ (void)read:(NSInputStream *)inputStream bytes:(uint8_t *)bytes length:(long)length error:(NSError **)error
{
    if (length <= 0)
        return;
    
    long readSoFar = 0;
    while (readSoFar < length) {
        long read = [inputStream read:bytes + readSoFar maxLength:length - readSoFar];
        
        if (read < 0)
        {
            if (error)
                *error = [NSError errorWithDomain:ERROR code:ERROR_INPUTSTREAM userInfo:nil];
            return;
        }
        
        readSoFar += read;
    }
}

+ (NSData *)read:(NSInputStream *)inputStream error:(NSError **)error
{
    uint8_t len_bytes[8];
    [self read: inputStream bytes:len_bytes length:8 error:error];
    
    if (error && *error)
        return nil;
    
    long length = *((long *)len_bytes);
    uint8_t *bytes = (uint8_t *)malloc(length);
    
    [self read:inputStream bytes:bytes length:length error:error];
    
    NSData *data = [NSData dataWithBytes:bytes length:length];
    free(bytes);
    
    return data;
}


+ (void)send:(NSOutputStream *)outputStream bytes:(const uint8_t *)bytes length:(long)length error:(NSError **)error
{
    if (length <= 0)
        return;
    
    long wroteSoFar = 0;
    
    while (wroteSoFar < length)
    {
        long wrote = [outputStream write:bytes + wroteSoFar maxLength:length - wroteSoFar];
        
        if (wrote < 0)
        {
            if (error)
                *error = [NSError errorWithDomain:ERROR code:ERROR_OUTPUTSTREAM userInfo:nil];
            return;
        }
        
        wroteSoFar += wrote;
    }
}

+ (void)send:(NSOutputStream *)outputStream data:(NSData *)data error:(NSError **)error
{
    const uint8_t *bytes = data.bytes;
    
    long len = [data length];
    const uint8_t *len_ptr = (uint8_t *) &len;
    
    [self send:outputStream bytes:len_ptr length:8 error:error];
    if (error && *error)
        return;
    
    [self send:outputStream bytes:bytes length:len error:error];
}
@end
