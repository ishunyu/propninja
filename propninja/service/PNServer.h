//
//  PNServer.h
//  propninja
//
//  Created by Shun Yu on 8/18/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyFileInfoConfig.h"

@interface PNServer : NSObject
- (void)start;
- (void)startInBackgroundWithCallback: (void (^)(BOOL)) callback;
- (BOOL)index:(PNPropertyFileInfoConfig *)pFileInfoConfig;
- (void)stop;

- (NSDictionary *)sendRequest:(NSDictionary *)dict;
@end
