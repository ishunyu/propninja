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
#import "PNServiceUtils.h"
#import "PNApplicationUtils.h"

#import "PNServer.h"
#import "PNService.h"

@interface PNService ()
@property (strong, nonatomic, readwrite) PNPropertyFileInfoConfig *pFilesConfig;
@property (strong, nonatomic) PNServer *pServer;
@end

@implementation PNService

- (id)init
{
    self = [super init];
    if (self) {
        self.pFilesConfig = [[PNPropertyFileInfoConfig alloc] init];
        self.pServer = [[PNServer alloc] init];
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
    NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForIndex:[self.pFilesConfig arrayOfPaths]]];
    if ([data[@"value"] boolValue]) {
        DDLogInfo(@"indexed");
    }
    else {
        DDLogError(@"index failed");
    }
}

- (NSArray *)searchProperties:(NSString *)search
{
    NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForSearch:search]];
    return [PNServiceUtils constructPropertiesFromSearchResult:data[@"value"] pFileInfoConfig:self.pFilesConfig];
}

- (void)setProperty:(PNProperty *)property
{
    [self.pServer sendRequest:[PNServiceUtils dictForSet:property]];
}

- (void) stop
{
    [self.pServer stop];
    DDLogInfo(@"stopped");
}
@end
