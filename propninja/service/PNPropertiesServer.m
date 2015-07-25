//
//  PNServer.m
//  propninja
//
//  Created by Shun Yu on 12/19/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "PNLoggerUtils.h"
#import "PNSerializationUtils.h"
#import "PNStreamUtils.h"
#import "PNPropertiesServerUtils.h"

#import "PNProperty.h"

#import "PNPropertiesServer.h"

@interface PNPropertiesServer ()
@property (nonatomic, readwrite) int port;
@property (strong, nonatomic) NSTask *task;
@end

@implementation PNPropertiesServer

- (void)preStart
{
    self.port = [PNStreamUtils findOpenPort];
}

- (void)doStart
{
    self.task = [[NSTask alloc] init];
    
    self.task.launchPath = [PNPropertiesServerUtils pathForServer];
    self.task.arguments = [PNPropertiesServerUtils arguments:self.port];
    
    [self.task launch];
}

- (BOOL)ready
{
    [NSThread sleepForTimeInterval:0.5f];
    
    int tries = 25;
    while (tries-- > 0) {
        PNStreamConnection *connection = [self createConnection];
        NSError *error = nil;
        
        [connection receive:[PNPropertiesServerUtils requestForStatus] error:&error];
        
        if (error)
        {
            [connection close];
            [NSThread sleepForTimeInterval:0.1f];
            continue;
        }
        
        [connection close];
        return YES;
    }
    
    DDLogInfo(@"Server not ready...");
    return NO;
}

- (BOOL)start
{
    [self preStart];
    [self doStart];
    return [self ready];
}

- (void)stop
{
    [self.task terminate];
    self.task = nil;
}

- (PNStreamConnection *) createConnection
{
    return [[PNStreamConnection alloc] initWithUrl:@"localhost" port:self.port];
}

@end
