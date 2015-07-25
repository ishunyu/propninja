//
//  PNLoggerUtils.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"

@implementation PNLoggerUtils

+ (void)load
{
    [[DDTTYLogger sharedInstance] setLogFormatter:[[PNLineNumberLogFormatter alloc] init]];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:LOG_LEVEL_ALL];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:[[PNLineNumberLogFormatter alloc] init]];
    
    [DDLog addLogger:fileLogger withLogLevel:LOG_LEVEL_INFO];
}

@end

@interface PNLineNumberLogFormatter ()
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation PNLineNumberLogFormatter
- (id)init
{
    if (self = [super init]) {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *timestamp = [self.formatter stringFromDate:logMessage->timestamp];
    NSString *logLevel = [self logLevel:logMessage->logFlag];
    NSString *path = [NSString stringWithCString:logMessage->file encoding:NSASCIIStringEncoding];
    NSString *fileLineNumber = [NSString stringWithFormat:@"%@:%d", [path lastPathComponent], logMessage->lineNumber];
    
    return [NSString stringWithFormat:@"%@ [%@] %-32s %@",timestamp, logLevel, [fileLineNumber UTF8String], logMessage->logMsg];
}

- (NSString *)logLevel:(int)logFlag
{
    switch (logFlag)
    {
        case LOG_FLAG_ERROR :
            return @"E";
        case LOG_FLAG_WARN  :
            return @"W";
        case LOG_FLAG_INFO  :
            return @"I";
        case LOG_FLAG_DEBUG :
            return @"D";
        default             :
            return @"V";
    }
}
@end