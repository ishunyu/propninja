//
//  PNPropertiesTableCellView.h
//  propninja
//
//  Created by Shun Yu on 2/6/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PNProperty.h"
#import "PNTextField.h"

@interface PNPropertiesTableCellView : NSTableCellView
<
    PNTextFieldDelegate
>
@property (nonatomic) NSUInteger index;

@property (weak) IBOutlet NSTextField *keyLabel;
@property (weak) IBOutlet NSTextField *fileLabel;
@property (weak) IBOutlet PNTextField *valueField;

- (void)populate:(id)delegate index:(NSUInteger)index property:(PNProperty *)property;
- (void)deselect;
@end

@protocol PNPropertiesTableCellViewDelegate <NSObject>

- (void)cellHeightDidChange:(PNPropertiesTableCellView *)cellView;

@end
