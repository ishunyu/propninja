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
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation PNService

- (id)init
{
    self = [super init];
    if (self) {
        _pServer = [[PNServer alloc] init];
        _pFilesConfig = [[PNPropertyFileInfoConfig alloc] init];
        _queue = dispatch_queue_create(NAME_QUEUE_PNSERVICE, nil);
        [self _init];
    }
    
    return self;
}

- (void)_init
{
    [self _start];
    [self _index];
}

- (void)_start
{
    [self dispatch_async:
     ^{
         [self.pServer start];
         DDLogInfo(@"started");
     }];
}

- (void)_index
{
    [self dispatch_async:
     ^{
         [self.pServer index:self.pFilesConfig];
         DDLogInfo(@"properties indexed");
     }];
}

- (void)getProperties:(NSArray *)properties callback:(void (^)(NSArray *))callback
{
    [self dispatch_async:
     ^{
         NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForGet:properties]];
         NSArray *result = [PNServiceUtils constructPropertiesFromSearchResult:data[@"value"]
                                                               pFileInfoConfig:self.pFilesConfig];
         callback(result);
     }];
}

- (void)searchProperties:(NSString *)search callback:(void (^)(NSArray *))callback
{
    [self dispatch_async:
     ^{
         NSDictionary *data = [self.pServer sendRequest:[PNServiceUtils dictForSearch:search]];
         NSArray *result = [PNServiceUtils constructPropertiesFromSearchResult:data[@"value"]
                                                               pFileInfoConfig:self.pFilesConfig];
         callback(result);
     }];
}

- (void)setProperty:(PNProperty *)property
{
    [self dispatch_async:
     ^{
         [self.pServer sendRequest:[PNServiceUtils dictForSet:property]];
     }];
}

- (void) stop
{
    [self dispatch_async:
     ^{
         [self.pServer stop];
         DDLogInfo(@"stopped");
     }];
}

- (void)dispatch_async:(void(^)())block
{
    dispatch_async(self.queue, block);
}
@end
