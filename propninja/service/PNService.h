//
//  PNService.h
//  propninja
//
//  Created by Shun Yu on 8/7/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyFileInfoConfig.h"
#import "PNProperty.h"

@interface PNService : NSObject
@property (strong, nonatomic, readonly) PNPropertyFileInfoConfig *pFilesConfig;

- (void)getProperties:(NSArray *)properties callback:(void(^)(NSArray *))callback;
- (void)searchProperties:(NSString *)search callback:(void(^)(NSArray *))callback;
- (void)setProperty:(PNProperty *)property;
- (void)stop;
@end
