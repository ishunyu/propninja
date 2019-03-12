//
//  PNLoggerUtils.h
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>

//static const int ddLogLevel = LOG_LEVEL_INFO;
static const int ddLogLevel = LOG_LEVEL_DEBUG;
//static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface PNLoggerUtils : NSObject

@end

@interface PNLineNumberLogFormatter : NSObject<DDLogFormatter>

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;

@end
