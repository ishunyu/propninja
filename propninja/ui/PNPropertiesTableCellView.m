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
@property (nonatomic, strong) id<PNPropertiesTableCellViewDelegate> delegate;
@property (nonatomic) NSInteger baseHeight;
@end

@implementation PNPropertiesTableCellView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.baseHeight = self.bounds.size.height;
}

- (void)populate:(id)delegate index:(NSUInteger)index property:(PNProperty *)property
{
    self.index = index;
    self.keyLabel.stringValue = property.key;
    self.valueField.stringValue = property.value;
    self.valueField.delegate = delegate;
    self.valueField.myDelegate = self;
    self.fileLabel.stringValue = property.pFileInfo.label;
    self.delegate = delegate;
}

- (void)deselect
{
    self.bounds = CGRectMake(self.bounds.origin.x,
                             self.bounds.origin.y,
                             self.bounds.size.width,
                             self.baseHeight);
    [self.delegate cellHeightDidChange:self];
}

- (void)selected
{
    self.bounds = CGRectMake(self.bounds.origin.x,
                             self.bounds.origin.y,
                             self.bounds.size.width,
                             self.baseHeight * 3);
    [self.delegate cellHeightDidChange:self];
}

#pragma mark PNTextFieldDelegate
- (void)becameFirstResponder:(PNTextField *)textField
{
    DDLogInfo(@"textField becameFirstResponder");
    [self selected];
}
@end
