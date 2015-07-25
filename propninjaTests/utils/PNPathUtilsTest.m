//
//  PNPathUtilsTest.m
//  propninja
//
//  Created by Shun Yu on 2/7/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "PNLoggerUtils.h"
#import "PNPathUtils.h"

@interface PNPathUtilsTest : XCTestCase

@end

@implementation PNPathUtilsTest

- (void)testEmpty {
    NSString *input = @"";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"");
}

- (void)testRoot
{
    NSString *input = @"/";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"/");
}

- (void)testFolder
{
    NSString *input = @"/Users";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"/Users");
}

- (void)testFolderWithTrailingForwardSlash
{
    NSString *input = @"/Users/";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"/Users/");
}

- (void)testTilda
{
    NSString *input = @"~";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"~");
}

- (void)testAutocomplete
{
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:@"/U"]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:@"/Us"]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:@"/Use"]);
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:@"/User"]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:@"/Users"]);
    
    NSString *input = @"/Us";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"/Users");
}

- (void)testAutocompleteWithTilda
{
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Desktop" stringByExpandingTildeInPath]]);

    NSString *desktopDirPath = @"~/Desktop";
    
    for (NSUInteger i = 3; i < (desktopDirPath.length - 1); i++)
    {
        NSString *desktopDirSubstring = [desktopDirPath substringToIndex:i];
        DDLogInfo(@"%@", desktopDirSubstring);
        XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:[desktopDirSubstring stringByExpandingTildeInPath]]);
    }
    
    NSString *input = @"~/Desk";
    NSString *output = [PNPathUtils autocomplete:input];
    
    XCTAssertEqualObjects(output, @"~/Desktop");
}

@end
