//
//  PNPropertiesTableCellView.m
//  propninja
//
//  Created by Shun Yu on 2/6/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "NSString+Utilities.h"

#import "PNPropertiesTableCellView.h"
@interface PNPropertiesTableCellView ()
@property (nonatomic, strong) id<PNPropertiesTableCellViewDelegate> delegate;
@property (nonatomic) NSInteger baseHeight;
@property (nonatomic) BOOL isSelected;
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
    DDLogVerbose(@"deselect bounds.height: %f", self.bounds.size.height);
    self.isSelected = NO;
    [self.delegate cellHeightDidChange:self];
}

- (void)selected
{
    DDLogVerbose(@"selected bounds.height: %f", self.bounds.size.height);
    self.isSelected = YES;
    [self.delegate cellHeightDidChange:self];
}

- (NSInteger)height;
{
    return self.baseHeight * (self.isSelected ? [self linesForEditing] : 1);
}

- (NSUInteger)linesForEditing
{
    NSUInteger numberOfLines = [self.valueField.stringValue numberOfLines];
    if (numberOfLines <= 1) {
        return 1;
    }
    
    if (numberOfLines <= 4) {
        return 3;
    }
    
    return 4;
}

#pragma mark PNTextFieldDelegate
- (void)becameFirstResponder:(PNTextField *)textField
{
    [self selected];
}
@end
