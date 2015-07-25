//
//  PNMenuDelegate.h
//  propninja
//
//  Created by Shun Yu on 12/20/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNAppDelegate.h"

@interface PNMenuController : NSObject <NSMenuDelegate>
- (id)initWithAppDelegate:(PNAppDelegate *)appDelegate;
- (void)show:(id)sender;
@end
