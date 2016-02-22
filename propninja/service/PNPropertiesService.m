//
//  PNPropertiesService.m
//  propninja
//
//  Created by Shun Yu on 1/30/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"
#import "PNSerializationUtils.h"
#import "PNPropertiesServerUtils.h"

#import "PNPropertiesServer.h"

#import "PNPropertiesService.h"

@interface PNPropertiesService ()
@property (strong, nonatomic, readwrite) PNPropertyFileInfoConfig *configuration;
@property (strong, nonatomic) PNPropertiesServer *server;
@property (strong, nonatomic) PNStreamConnection *connection;
@end

@implementation PNPropertiesService
- (id)init
{
    self = [super init];
    if (self)
    {
        self.configuration = [[PNPropertyFileInfoConfig alloc] init];
        self.server = [[PNPropertiesServer alloc] init];
        [self performSelectorInBackground:@selector(_start) withObject:nil];
    }
    
    return self;
}

- (void)_start
{
    if ([self.server start]) {
        DDLogInfo(@"Service starting...");
        
        PNStreamConnection *connection = [self.server createConnection];
        [self _index:connection];
        
        self.connection = connection;
        
        DDLogInfo(@"Service started...");
    }
}

#pragma mark Index

- (BOOL)ready
{
    if (self.connection)
        return YES;
    
    return NO;
}

- (void)_index:(PNStreamConnection *)connection
{
    NSArray *paths = [self.configuration paths];
    NSData *request = [PNPropertiesServerUtils requestForIndex:paths];
    
    [connection send:request error:nil];
}

- (void)index
{
    if (![self ready])
        return;
    
    [self _index:self.connection];
}

#pragma mark Search

- (NSArray *)constructPropertiesFromSearchResult:(NSArray *)results
{
    NSMutableArray *properties = [[NSMutableArray alloc] init];
    
    for (NSArray* result in results) {
        [properties addObject:[[PNProperty alloc] initWithFilePath:result[0] key:result[1] value:result[2]]];
    }
    
    return properties;
}

- (NSArray *)searchProperties:(NSString *)search
{
    if (![self ready])
        return nil;
    
    NSError *error = nil;
    NSData *response_data = [self.connection receive:[PNPropertiesServerUtils requestForSearch:search] error:&error];
    
    if (error)
        return nil;
    
    NSDictionary *response_object = [PNSerializationUtils deserialize:response_data];
    NSLog(@"%@", response_object);
    return [self constructPropertiesFromSearchResult:response_object[@"value"]];
}

#pragma mark Set

- (void)setProperty:(PNProperty *)property
{
    if (![self ready])
        return;
    
    [self.connection send:[PNPropertiesServerUtils requestForSet:property] error:nil];
}

- (void)stop
{
    [self.connection send:[PNPropertiesServerUtils requestForStop] error:nil];
    [self.connection close];
    [self.server stop];
}

@end
