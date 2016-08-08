//
//  PNStandardInputOutputServer.m
//  propninja
//
//  Created by Shun Yu on 8/18/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNPropertiesServerUtils.h"
#import "PNSerializationUtils.h"
#import "PNStreamUtils.h"

#import "PNStandardInputOutputServer.h"

@interface PNStandardInputOutputServer()
@property (weak, nonatomic) NSFileHandle *writeFileHandle;
@property (weak, nonatomic) NSFileHandle *readFileHandle;
@property (strong, nonatomic) NSTask *task;
@end

@implementation PNStandardInputOutputServer

- (void)startInBackgroundWithCallback:(void (^)(BOOL))callback
{
    [self performSelectorInBackground:@selector(doStartInBackgroundWithCallback:) withObject:callback];
}

- (void)doStartInBackgroundWithCallback:(void (^)(BOOL)) callback
{
    callback([self launchNSTask]);
}

- (BOOL)launchNSTask
{
    NSPipe *writePipe = [[NSPipe alloc] init];
    NSPipe *readPipe = [[NSPipe alloc] init];
    
    DDLogInfo(@"pathForLogFolder: %@", [PNPropertiesServerUtils pathForLogFolder]);
    
    self.task = [[NSTask alloc] init];
    [self.task setLaunchPath: [PNPropertiesServerUtils pathForStandardInputOutputServer]];
    [self.task setArguments: @[[PNPropertiesServerUtils pathForLogFolder]]];
    [self.task setStandardInput:writePipe];
    [self.task setStandardOutput:readPipe];
    self.writeFileHandle = [writePipe fileHandleForWriting];
    self.readFileHandle = [readPipe fileHandleForReading];
    [self.task launch];
    
    return [PNPropertiesServerUtils waitForServerReady:self.readFileHandle];
}

- (void)stop
{
    [self sendRequest:[PNPropertiesServerUtils dictForStop]];
    
    [self.task terminate];
    [self.writeFileHandle closeFile];
    [self.readFileHandle closeFile];
}

- (NSDictionary *)sendRequest:(NSDictionary *)dict
{
    NSData *dictData = [PNSerializationUtils serialize:dict];
    NSData *data = [PNStreamUtils sendData:dictData writeFileHandle:self.writeFileHandle readFileHandle:self.readFileHandle];
    return [PNSerializationUtils deserialize:data];
}
@end
