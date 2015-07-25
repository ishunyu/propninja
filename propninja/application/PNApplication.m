//
//  PNApplication.m
//  propninja
//
//  Created by Shun Yu on 12/14/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNApplication.h"

@implementation PNApplication
- (void)sendEvent:(NSEvent *)event
{
    if (event.type == NSKeyDown)
    {
        NSString *inputKey = [event.charactersIgnoringModifiers lowercaseString];
        NSEventModifierFlags modiferFlags = event.modifierFlags & NSDeviceIndependentModifierFlagsMask;
        
        if ((modiferFlags) == NSCommandKeyMask || (modiferFlags) == (NSCommandKeyMask | NSAlphaShiftKeyMask))
        {
            if ([inputKey isEqualToString:@"x"])
            {
                if ([self sendAction:@selector(cut:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"c"])
            {
                if ([self sendAction:@selector(copy:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"v"])
            {
                if ([self sendAction:@selector(paste:) to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:NSSelectorFromString(@"undo:") to:nil from:self])
                    return;
            }
            else if ([inputKey isEqualToString:@"a"])
            {
                if ([self sendAction:@selector(selectAll:) to:nil from:self])
                    return;
            }
        }
        else if ((modiferFlags) == (NSCommandKeyMask | NSShiftKeyMask) ||
                 (modiferFlags) == (NSCommandKeyMask | NSShiftKeyMask | NSAlphaShiftKeyMask))
        {
            if ([inputKey isEqualToString:@"z"])
            {
                if ([self sendAction:NSSelectorFromString(@"redo:") to:nil from:self])
                    return;
            }
        }
    }
    [super sendEvent:event];
}
@end
