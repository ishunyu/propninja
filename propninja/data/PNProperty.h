//
//  PNProperty.h
//  propninja
//
//  Created by Shun Yu on 1/4/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNProperty : NSObject
@property (strong, nonatomic, readonly) NSString *filePath;
@property (strong, nonatomic, readonly) NSString *key;
@property (strong, nonatomic, readonly) NSString *value;

-(id)initWithFilePath:(NSString *)filePath key:(NSString *)key value:(NSString *)value;
-(id)initWithProperty:(PNProperty *)property value:(NSString *)value;
@end
