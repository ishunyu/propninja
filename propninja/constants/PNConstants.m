//
//  PNConstants.m
//  propninja
//
//  Created by Shun Yu on 12/24/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNConstants.h"

NSString *ERROR = @"PN_ERROR";
long ERROR_INPUTSTREAM = 1;
long ERROR_OUTPUTSTREAM = 2;

NSString *DIR_SCRIPTS = @"scripts";
NSString *DIR_TEMP = @"scripts/tmp";

NSString *FILE_TYPE_PYTHON = @"py";
NSString *FILE_TYPE_LOCK = @"lock";
NSString *FILE_TYPE_JSON = @"json";


NSString *FILE_PROPERTIES_SERVER = @"server";
NSString *FILE_STANDARD_INPUT_OUTPUT_PROPERTIES_SERVER = @"standardinputoutputserver";

NSString *KEY_CONFIG_HOTKEY = @"CONFIG_HOTKEY";
NSUInteger VALUE_CONFIG_HOTKEY_DEFAULT_MODIFIER_FLAGS = NSAlternateKeyMask | NSCommandKeyMask;
unsigned char VALUE_CONFIG_HOTKEY_DEFAULT_KEY_CODE = 47;

NSString *KEY_PROPERTY_MODIFIER_FLAGS = @"modifierFlags";
NSString *KEY_PROPERTY_KEY_CODE = @"keyCode";

NSString *KEY_CONFIG_PROPERTY_FILES = @"CONFIG_PROPERTY_FILES";

NSString *KEY_PROPERTY_TAG = @"tag";
NSString *KEY_PROPERTY_PATH = @"path";
NSString *KEY_PROPERTY_ENABLED = @"enabled";
