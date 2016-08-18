//
//  PNStandardInputOutputServer.h
//  propninja
//
//  Created by Shun Yu on 8/18/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNStandardInputOutputServer : NSObject
- (void)startInBackgroundWithCallback: (void (^)(BOOL)) callback;
- (void)stop;

- (NSDictionary *)sendRequest:(NSDictionary *)dict;
@end
