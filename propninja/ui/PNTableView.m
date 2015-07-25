//
//  PNTableView.m
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNTableHeaderCell.h"

#import "PNTableView.h"

@implementation PNTableView

- (void)replaceHeaders
{
    for (NSTableColumn *column in self.tableColumns)
        column.headerCell = [[PNTableHeaderCell alloc] initWithHeaderCell:column.headerCell];
    
    [self.cornerView removeFromSuperview];
}
@end
