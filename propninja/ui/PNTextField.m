//
//  PNTextField.m
//  propninja
//
//  Created by Shun Yu on 10/23/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNTextField.h"

@implementation PNTextField

- (BOOL)becomeFirstResponder
{
    if ([super becomeFirstResponder]) {
        [self.myDelegate becameFirstResponder:self];
        return YES;
    }
    return NO;
}

@end
