//
//  PNAppDelegate.h
//  propninja
//
//  Created by Shun Yu on 12/12/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PNPropertiesServer.h"

@interface PNAppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic, readonly) PNPropertiesServer *propertiesServer;

- (void)quit:(id)sender;

- (void)showMenu:(id)sender;
- (void)showProperties:(id)sender;
- (void)showPreferences:(id)sender;
@end
