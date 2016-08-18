//
//  PNPropertiesTableCellView.h
//  propninja
//
//  Created by Shun Yu on 2/6/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PNProperty.h"

@interface PNPropertiesTableCellView : NSTableCellView
@property (nonatomic) NSUInteger index;

@property (weak) IBOutlet NSTextField *keyLabel;
@property (weak) IBOutlet NSTextField *fileLabel;
@property (weak) IBOutlet NSTextField *valueField;

- (void)populate:(id)delegate index:(NSUInteger)index property:(PNProperty *)property propertyFileLabel:(NSString *)label;
@end
