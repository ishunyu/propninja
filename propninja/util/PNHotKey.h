//
//  PNHotKey.h
//  propninja
//
//  Created by Shun Yu on 2/27/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNHotKey : NSObject <NSCoding>
@property (nonatomic, readonly) NSUInteger modifierFlags;
@property (nonatomic, readonly) unsigned short keyCode;

- (id)initWithModifierFlags:(NSUInteger)modiferFlags keyCode:(unsigned short)keyCode;
@end
