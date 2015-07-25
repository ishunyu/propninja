//
//  NSString+Utilities.h
//  propninja
//
//  Created by Shun Yu on 12/27/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Utilities)
- (NSString *)strip;
- (BOOL)isEmpty;
- (unichar)lastCharacter;

+ (BOOL)isNullOrEmpty:(NSString *)string;
@end
