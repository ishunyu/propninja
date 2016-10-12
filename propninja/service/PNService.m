//
//  PNService.m
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
        PNPropertyFileInfoConfig *pFilesConfig = [[PNPropertyFileInfoConfig alloc] init];
        PNServer *pServer = [[PNServer alloc] init];
        
        [pServer startInBackgroundWithCallback:^(BOOL success){
            if (success) {
                self.pServer = pServer;
                DDLogInfo(@"started");
                
                if ([pServer index:pFilesConfig]) {
                    self.pFilesConfig = pFilesConfig;
                    DDLogInfo(@"properties indexed");
                }
                
                return;
            }
            
            [pServer stop];
            DDLogError(@"start failed");
        }];
    }
    
    return self;
}

- (NSArray *)searchProperties:(NSString *)search
{
    NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForSearch:search]];
    return [PNServiceUtils constructPropertiesFromSearchResult:data[@"value"]
                                               pFileInfoConfig:self.pFilesConfig];
}

- (void)setProperty:(PNProperty *)property
{
    [self.pServer sendRequest:[PNServiceUtils dictForSet:property]];
}

- (NSArray *)getProperties:(NSArray *)properties
{
    NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForGet:properties]];
    return [PNServiceUtils constructPropertiesFromSearchResult:data[@"value"]
                                               pFileInfoConfig:self.pFilesConfig];
}

- (void) stop
{
    [self.pServer stop];
    DDLogInfo(@"stopped");
}
@end
