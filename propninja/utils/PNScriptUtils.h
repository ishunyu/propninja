//
//  PNProcessUtils.h
//  propninja
//
//  Created by Shun Yu on 12/12/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNScriptUtils : NSObject
+ (NSString *) run:(NSString *) command args:(NSArray *) args;
+ (NSString *) run:(NSString *) command;
+ (NSString *) runPython:(NSString *) script args:(NSArray *) args;
+ (NSString *) runPython:(NSString *) script;
@end
