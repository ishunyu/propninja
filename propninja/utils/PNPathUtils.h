//
//  PNPathUtils.h
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNPathUtils : NSObject
+ (NSString *)pathForResource: (NSString *)resource;
+ (NSString *)pathForRelativePath: (NSString *)relativePath;
+ (NSString *)autocomplete:(NSString *)path;
@end
