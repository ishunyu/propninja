//
//  PNServer.h
//  propninja
//
//  Created by Shun Yu on 12/19/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNStreamConnection.h"
#import "PNProperty.h"

@interface PNPropertiesServer : NSObject
@property (nonatomic, readonly) int port;
@property (strong, nonatomic, readonly) PNStreamConnection *streamConnection;

- (BOOL)start;
- (void)stop;

- (PNStreamConnection *) createConnection;
@end


