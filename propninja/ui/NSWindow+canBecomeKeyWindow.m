//
//  NSObject+NSWindow_canBecomeKeyWindow.m
//  propninja
//
//  Created by Shun Yu on 12/13/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "NSWindow+canBecomeKeyWindow.h"

@implementation NSWindow (canBecomeKeyWindow)
//This is to fix a bug with 10.7 where an NSPopover with a text field cannot be edited if its parent window won't become key
//The pragma statements disable the corresponding warning for overriding an already-implemented method
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (BOOL)canBecomeKeyWindow
{
    return YES;
}
#pragma clang diagnostic pop
@end
