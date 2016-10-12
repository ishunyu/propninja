//
//  PNPropertyUsageMetrics.h
//  propninja
//
//  Created by Shun Yu on 10/11/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNProperty.h"

@interface PNPropertyUsageMetrics : NSObject <NSCoding>
- (NSArray *)getTopVisitedProperties:(NSInteger) top;
- (void)edited:(PNProperty *) property;
@end
