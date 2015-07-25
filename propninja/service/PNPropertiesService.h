//
//  PNPropertiesService.h
//  propninja
//
//  Created by Shun Yu on 1/30/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyFileInfoConfig.h"
#import "PNStreamConnection.h"
#import "PNProperty.h"

@interface PNPropertiesService : NSObject
@property (strong, nonatomic, readonly) PNPropertyFileInfoConfig *configuration;

- (void)index;
- (NSArray *)searchProperties:(NSString *)search;
- (void)setProperty:(PNProperty *)property;

- (void) stop;

@end
