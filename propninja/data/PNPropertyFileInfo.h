//
//  PNPropertyFile.h
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNPropertyFileInfo : NSObject <NSCoding>
@property (strong, nonatomic, readonly) NSString *label;
@property (strong, nonatomic, readonly) NSString *path;
@property (strong, nonatomic, readonly) NSString *absolutePath;
@property (nonatomic, readwrite) BOOL enabled;

- (id)initWithLabel:(NSString *)label path:(NSString *)path enabled:(BOOL)enabled;
@end
