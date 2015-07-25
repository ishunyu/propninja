//
//  PNPropertyFile.h
//  propninja
//
//  Created by Shun Yu on 1/31/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PNPropertyFileInfo.h"

@interface PNPropertyFileInfoConfig : NSObject
- (long)count;
- (NSArray *)paths;
- (void)save;

- (void)addEmptyPropertyFileInfo;

- (PNPropertyFileInfo *)propertyFileInfoForPath:(NSString *)path;

- (PNPropertyFileInfo *)propertyFileInfoForIndex:(long)index;
- (void)setPropertyFileInfo:(PNPropertyFileInfo *)fileInfo index:(long)index;
- (void)removePropertyFileInfoForIndex:(long)index;
@end
