//
//  PNTextField.m
//  propninja
//
//  Created by Shun Yu on 10/23/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNTextField.h"

@implementation PNTextField

- (BOOL)becomeFirstResponder
{
    BOOL status = [super becomeFirstResponder];
    DDLogInfo(@"becomeFirstResponder status: %d", status);
    return status;
}
@end
