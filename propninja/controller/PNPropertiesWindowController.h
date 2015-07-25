//
//  PNWindow.h
//  propninja
//
//  Created by Shun Yu on 12/13/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PNAppDelegate.h"
#import "PNPropertiesTableView.h"

@interface PNPropertiesWindowController : NSWindowController
<
    NSWindowDelegate,
    NSTextFieldDelegate,
    NSTableViewDelegate,
    NSTableViewDataSource,
    PNPropertiesTableViewDelegate
>

- (id)initWithWindowNibName:(NSString *)windowNibName appDelegate:(PNAppDelegate *)appDelegate;
@end
