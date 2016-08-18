//
//  PNStandardInputOutputPropertiesService.h
//  propninja
//
//  Created by Shun Yu on 8/7/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyFileInfoConfig.h"
#import "PNProperty.h"

@interface PNStandardInputOutputPropertiesService : NSObject
@property (strong, nonatomic, readonly) PNPropertyFileInfoConfig *pFilesConfig;

- (void)index;
- (NSArray *)searchProperties:(NSString *)search;
- (void)setProperty:(PNProperty *)property;

- (void) stop;
@end
