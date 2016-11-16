//
//  PNServer.m
//  propninja
//
//  Created by Shun Yu on 8/18/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNConstants.h"
#import "PNServiceUtils.h"
#import "PNSerializationUtils.h"
#import "PNStreamUtils.h"

#import "PNServer.h"

@interface PNServer()
@property (strong, nonatomic) NSTask *task;
@property (weak, nonatomic) NSFileHandle *writeFileHandle;
@property (weak, nonatomic) NSFileHandle *readFileHandle;
@end

@implementation PNServer

- (void)start
{
    [self launchNSTask];
}

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
    
    DDLogInfo(@"log folder: %@", [PNServiceUtils pathForLogFolder]);
    
    self.task = [[NSTask alloc] init];
    [self.task setLaunchPath: [PNServiceUtils pathForStandardInputOutputServer]];
    [self.task setArguments: @[[PNServiceUtils pathForLogFolder]]];
    [self.task setEnvironment:[PNServiceUtils environmentForServer]];
    [self.task setStandardInput:writePipe];
    [self.task setStandardOutput:readPipe];
    self.writeFileHandle = [writePipe fileHandleForWriting];
    self.readFileHandle = [readPipe fileHandleForReading];
    [self.task launch];
    
    return [PNServiceUtils waitForServerReady:self.readFileHandle];
}

- (BOOL)index:(PNPropertyFileInfoConfig *)pFileInfoConfig
{

    NSDictionary *data = [self sendRequest:[PNServiceUtils dictForIndex:[pFileInfoConfig arrayOfPaths]]];
    return [data[@"value"] boolValue];
}

- (void)stop
{
    [self sendRequest:[PNServiceUtils dictForStop]];
    
    [self.task terminate];
    [self.writeFileHandle closeFile];
    [self.readFileHandle closeFile];
}

- (NSDictionary *)sendRequest:(NSDictionary *)dict
{
    NSData *dictData = [PNSerializationUtils serialize:dict];
    NSData *data = [PNStreamUtils sendData:dictData
                           writeFileHandle:self.writeFileHandle
                            readFileHandle:self.readFileHandle];
    
    return [PNSerializationUtils deserializeDictionary:data];
}
@end
