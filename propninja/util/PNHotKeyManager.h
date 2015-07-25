//
//  PNHotKeyUtils.h
//  propninja
//
//  Created by Shun Yu on 12/21/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDHotKeyCenter.h"

#import "PNHotKey.h"
#import "PNAppDelegate.h"

@interface PNHotKeyManager : NSObject
- (void)configure: (PNAppDelegate *)appDelegate;

- (DDHotKey *)getDDHotKey;

- (void)setAndRegisterHotKeyWithModiferFlag:(NSUInteger)modiferFlag keyCode:(unsigned short)keyCode;
- (void)registerHotKey;

+ (PNHotKeyManager *)sharedInstance;
@end
