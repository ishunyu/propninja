//
//  PNPropertiesTableCellView.m
//  propninja
//
//  Created by Shun Yu on 2/6/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"

#import "PNPropertiesTableCellView.h"
@interface PNPropertiesTableCellView ()

@end

@implementation PNPropertiesTableCellView
- (void)populate:(id)delegate index:(NSUInteger)index property:(PNProperty *)property
{
    self.index = index;
    self.keyLabel.stringValue = property.key;
    self.valueField.stringValue = property.value;
    self.valueField.delegate = delegate;
    self.fileLabel.stringValue = property.pFileInfo.label;
}

@end
