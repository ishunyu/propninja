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

NSString *PATH_SCRIPTS = @"scripts";
NSString *PATH_SERVER_LOG = @"scripts/server/tmp";
NSString *PATH_PYTHON_INDEXER = @"scripts/indexer";
NSString *PATH_PYTHON_PROPERTIES = @"scripts/properties";
NSString *PATH_PYTHON_SERVER = @"scripts/server";
NSString *PATH_PYTHON_WHOOSH = @"scripts/whoosh";
NSString *PATH_STANDARD_INPUT_OUTPUT_PROPERTIES_SERVER = @"scripts/server/standardinputoutputserver.py";

NSString *FILE_TYPE_PYTHON = @"py";
NSString *FILE_TYPE_LOCK = @"lock";
NSString *FILE_TYPE_JSON = @"json";

const char *NAME_QUEUE_PNSERVICE = "com.shunyu.propninja.PNService.queue";

NSString *KEY_CONFIG_HOTKEY = @"CONFIG_HOTKEY";
NSUInteger VALUE_CONFIG_HOTKEY_DEFAULT_MODIFIER_FLAGS = NSAlternateKeyMask | NSCommandKeyMask;
unsigned char VALUE_CONFIG_HOTKEY_DEFAULT_KEY_CODE = 47;

NSString *KEY_PROPERTY_MODIFIER_FLAGS = @"modifierFlags";
NSString *KEY_PROPERTY_KEY_CODE = @"keyCode";

NSString *KEY_CONFIG_PROPERTY_FILES = @"CONFIG_PROPERTY_FILES";
NSString *KEY_CONFIG_PROPERTY_USAGE_METRICS = @"CONFIG_PROPERTY_USAGE_METRICS";
NSString *KEY_PROPERTY_USAGE_METRICS_DATA = @"PROPERTY_USAGE_METRICS_DATA";
NSString *KEY_PROPERTY_USAGE_METRICS_ITEM_FILE = @"key";
NSString *KEY_PROPERTY_USAGE_METRICS_ITEM_KEY = @"file";


NSString *KEY_PROPERTY_TAG = @"tag";
NSString *KEY_PROPERTY_PATH = @"path";
NSString *KEY_PROPERTY_ENABLED = @"enabled";
