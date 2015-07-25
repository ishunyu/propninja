//
//  NSStringUtilitiesTest.m
//  propninja
//
//  Created by Shun Yu on 2/7/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "NSString+Utilities.h"

@interface NSStringUtilitiesTest : XCTestCase

@end

@implementation NSStringUtilitiesTest

- (void)testIsEmptyTrue
{
    XCTAssertTrue([@"" isEmpty]);
}

- (void)testIsEmptyFalse
{
    XCTAssertFalse([@"a" isEmpty]);
}

- (void)testIsNullOrEmptyTrue
{
    XCTAssertTrue([NSString isNullOrEmpty:nil]);
    XCTAssertTrue([NSString isNullOrEmpty:@""]);
}

- (void)testIsNullOrEmptyFalse
{
    XCTAssertFalse([NSString isNullOrEmpty:@"a"]);
}

- (void)testStripSpace
{
    XCTAssertEqualObjects([@"a " strip], @"a");
}

- (void)testStripNewline
{
    XCTAssertEqualObjects([@"a\n" strip], @"a");
}

- (void)testStripSpaceAndNewline
{
    XCTAssertEqualObjects([@"a \n" strip], @"a");
}

- (void)testLastChar
{
    XCTAssertEqual([@"abc" lastCharacter], 'c');
}

@end
