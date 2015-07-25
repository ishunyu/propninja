//
//  NSString+Utilities.m
//  propninja
//
//  Created by Shun Yu on 12/27/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString(Utilities)
- (NSString *)strip
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty
{
    return self.length == 0;
}

- (unichar)lastCharacter
{
    return [self characterAtIndex:self.length-1];
}

+ (BOOL)isNullOrEmpty:(NSString *)string
{
    return !string || [string isEmpty];
}
@end
