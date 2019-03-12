//
//  PNTableView.h
//  propninja
//
//  Created by Shun Yu on 12/14/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PNPropertiesTableCellView.h"
#import "PNTableView.h"

@interface PNPropertiesTableView : PNTableView
<
    NSTextFieldDelegate
>

- (void)selectNone;
- (void)selectFirstRow;
- (void)selectLastRow;
@end

@protocol PNPropertiesTableViewDelegate <NSObject>

@required
- (void)cellDidChange:(PNPropertiesTableCellView *)cell;
- (void)openTextEditor: (NSUInteger)row;
@end
