//
//  PNTextField.h
//  propninja
//
//  Created by Shun Yu on 10/23/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PNTextFieldDelegate;

@interface PNTextField : NSTextField
@property (strong, nonatomic) id<PNTextFieldDelegate> myDelegate;
@end

@protocol PNTextFieldDelegate <NSObject>
- (void)becameFirstResponder:(PNTextField *)textField;
@end