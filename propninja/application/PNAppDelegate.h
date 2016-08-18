//
//  PNAppDelegate.h
//  propninja
//
//  Created by Shun Yu on 12/12/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PNAppDelegate : NSObject <NSApplicationDelegate>

- (void)quit:(id)sender;

- (void)showMenu:(id)sender;
- (void)showProperties:(id)sender;
- (void)showPreferences:(id)sender;
@end
