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
- (NSArray *)arrayOfPaths;
- (void)saveToUserDefaults;

- (PNPropertyFileInfo *)pFileInfoForPath:(NSString *)path;
- (PNPropertyFileInfo *)pFileInfoForIndex:(long)index;

- (void)addEmptyPFileInfo;
- (void)setPFileInfo:(PNPropertyFileInfo *)fileInfo index:(long)index;
- (void)removePFileInfoForIndex:(long)index;
@end
