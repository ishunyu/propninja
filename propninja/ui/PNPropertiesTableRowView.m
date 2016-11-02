//
//  PNPropertiesTableRowView.m
//  propninja
//
//  Created by Shun Yu on 2/6/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNPropertiesTableRowView.h"

@implementation PNPropertiesTableRowView

- (void)drawSelectionInRect:(NSRect)dirtyRect
{
    [[NSColor secondarySelectedControlColor] setFill];
    NSRectFill(dirtyRect);
}

- (NSBackgroundStyle)interiorBackgroundStyle
{
    return NSBackgroundStyleLight;
}

@end
