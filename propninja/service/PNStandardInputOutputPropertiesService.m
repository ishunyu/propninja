//
//  PNStandardInputOutputPropertiesService.m
//  propninja
//
//  Created by Shun Yu on 8/7/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNConstants.h"
#import "PNLoggerUtils.h"
#import "PNSerializationUtils.h"
#import "PNStreamUtils.h"
#import "PNPropertiesServerUtils.h"
#import "PNApplicationUtils.h"

#import "PNStandardInputOutputServer.h"
#import "PNStandardInputOutputPropertiesService.h"

@interface PNStandardInputOutputPropertiesService ()
@property (strong, nonatomic, readwrite) PNPropertyFileInfoConfig *pFilesConfig;
@property (strong, nonatomic) PNStandardInputOutputServer *pServer;
@end

@implementation PNStandardInputOutputPropertiesService

- (id)init
{
    self = [super init];
    if (self) {
        self.pFilesConfig = [[PNPropertyFileInfoConfig alloc] init];
        self.pServer = [[PNStandardInputOutputServer alloc] init];
        [self.pServer startInBackgroundWithCallback:^(BOOL success){
            if (success){
                DDLogInfo(@"started");
                [self index];
            }
            else{
                DDLogError(@"start failed");
            }
        }];
    }
    
    return self;
}

- (void)index
{
    NSDictionary *data = [self.pServer sendRequest:[PNPropertiesServerUtils dictForIndex:[self.pFilesConfig arrayOfPaths]]];
    if ([data[@"value"] boolValue]) {
        DDLogInfo(@"indexed");
    }
    else {
        DDLogError(@"index failed");
    }
}

- (NSArray *)searchProperties:(NSString *)search
{
    NSDictionary *data = [self.pServer sendRequest:[PNPropertiesServerUtils dictForSearch:search]];
    return [PNPropertiesServerUtils constructPropertiesFromSearchResult:data[@"value"]];
}

- (void)setProperty:(PNProperty *)property
{
    [self.pServer sendRequest:[PNPropertiesServerUtils dictForSet:property]];
}

- (void) stop
{
    [self.pServer stop];
    DDLogInfo(@"%@ stopped", [self className]);
}
@end
