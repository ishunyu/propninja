//
//  PNNumericUtils.m
//  propninja
//
//  Created by Shun Yu on 1/30/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNNumericUtils.h"

@implementation PNNumericUtils

+ (int)randomNumberBetween:(int)min max:(int)max
{
    return min + arc4random_uniform(max - min + 1);
}

@end
