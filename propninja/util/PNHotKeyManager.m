//
//  PNHotKeyUtils.m
//  propninja
//
//  Created by Shun Yu on 12/21/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Carbon/Carbon.h>

#import "DDHotKeyCenter.h"

#import "PNConstants.h"

#import "PNConfigManager.h"
#import "PNHotKeyManager.h"

@interface PNHotKeyManager ()
@property (strong, nonatomic) PNAppDelegate *appDelegate;
@end

@implementation PNHotKeyManager
- (void)configure: (PNAppDelegate *)appDelegate
{
    self.appDelegate = appDelegate;
    [self ensureHotkey];
    [self registerHotKey];
}

- (PNHotKey *)getDefaultHotKey
{
    return [[PNHotKey alloc] initWithModifierFlags:VALUE_CONFIG_HOTKEY_DEFAULT_MODIFIER_FLAGS
                                             keyCode:VALUE_CONFIG_HOTKEY_DEFAULT_KEY_CODE];
}

- (PNHotKey *)getHotKey
{
    return [PNConfigManager hotKey];
}

- (DDHotKey *)getDDHotKey
{
    PNHotKey *hotKey = [self getHotKey];
    
    return [DDHotKey hotKeyWithKeyCode:hotKey.keyCode modifierFlags:hotKey.modifierFlags task:nil];
}

- (void)ensureHotkey
{
    if (![self getHotKey])
        [PNConfigManager setHotKey:[self getDefaultHotKey]];
}

- (void)setAndRegisterHotKeyWithModiferFlag:(NSUInteger)modiferFlag keyCode:(unsigned short)keyCode;
{
    [PNConfigManager setHotKey:[[PNHotKey alloc] initWithModifierFlags:modiferFlag keyCode:keyCode]];
    [self registerHotKey];
}

- (void)registerHotKey
{
    [[DDHotKeyCenter sharedHotKeyCenter] unregisterAllHotKeys];
    
    PNHotKey *hotKey = [self getHotKey];
    
    [[DDHotKeyCenter sharedHotKeyCenter] registerHotKeyWithKeyCode:hotKey.keyCode
                                                     modifierFlags:hotKey.modifierFlags
                                                            target:self.appDelegate
                                                            action:@selector(showProperties:)
                                                            object:[NSApplication sharedApplication]];
}

+ (PNHotKeyManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PNHotKeyManager *hotKeyManager;
    dispatch_once(&onceToken, ^{
        hotKeyManager = [[PNHotKeyManager alloc] init];
    });
    
    return hotKeyManager;
}
@end
