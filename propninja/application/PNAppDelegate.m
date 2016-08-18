//
//  PNAppDelegate.m
//  propninja
//
//  Created by Shun Yu on 12/12/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNConstants.h"

#import "PNHotKeyManager.h"
#import "PNLoggerUtils.h"
#import "PNStreamUtils.h"
#import "PNApplicationUtils.h"

#import "PNPropertiesWindowController.h"
#import "PNPreferencesWindowController.h"
#import "PNMenuController.h"
#import "PNAppDelegate.h"

@interface PNAppDelegate ()
@property (strong, nonatomic) PNMenuController *menu;
@property (strong, nonatomic) PNPropertiesWindowController *properties;
@property (strong, nonatomic) PNPreferencesWindowController *preferences;
@end

@implementation PNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSApplication sharedApplication] hide:self];
    
    self.menu = [[PNMenuController alloc] initWithAppDelegate:self];
    self.preferences = [[PNPreferencesWindowController alloc] initWithWindowNibName:@"PNPreferencesWindow"];
    
    [[PNHotKeyManager sharedInstance] configure:self];
}

- (void)applicationDidHide:(NSNotification *)notification
{
    [self.properties close];
    self.properties = nil;
    
    [self.preferences close];
}

#pragma mark - StatusMenuItem
- (void)showMenu:(id)sender
{
    [self.menu show:self];
}

- (void)showProperties:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    
    self.properties = [[PNPropertiesWindowController alloc] initWithWindowNibName:@"PNPropertiesWindow" appDelegate:self];
    [self.properties showWindow:self];
}

- (void)showPreferences:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    
    [self.preferences showWindow:self];
}

- (void)quit:(id)sender
{
    [PNApplicationUtils terminate];
}

@end
