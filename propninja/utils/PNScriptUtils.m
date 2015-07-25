//
//  PNProcessUtils.m
//  propninja
//
//  Created by Shun Yu on 12/12/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNScriptUtils.h"

@implementation PNScriptUtils
+ (NSString *) run:(NSString *) command args:(NSArray *) args
{
    for(NSString *arg in args) {
        command = [NSString stringWithFormat:@"%@ \"%@\"", command, arg];
    }
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments: @[@"-c", command]];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSString *data = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding: NSUTF8StringEncoding];
    
    [file closeFile];
    
    return data;
}

+ (NSString *)run:(NSString *) command
{
    return [self run:command args:nil];
}

+ (NSString *) commandForPython: (NSString *)script
{
    NSString *path = [[NSBundle mainBundle] pathForResource:script ofType:@"py" inDirectory:@"scripts"];
    return [@[@"python", path] componentsJoinedByString:@" "];
}

+ (NSString *) runPython: (NSString *) script
{
    return [self run:[self commandForPython:script] args:nil];
}

+ (NSString *) runPython:(NSString *) script args:(NSArray *) args
{
    return [self run:[self commandForPython:script] args:args];
}
@end
