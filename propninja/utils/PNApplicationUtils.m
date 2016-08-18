//
//  PNApplicationUtils.m
//  propninja
//
//  Created by Shun Yu on 8/14/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNApplicationUtils.h"

@implementation PNApplicationUtils
+ (void)terminate
{
    [[NSApplication sharedApplication] terminate:nil];
}
@end
