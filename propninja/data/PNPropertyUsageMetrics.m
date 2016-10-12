//
//  PNPropertyUsageMetrics.m
//  propninja
//
//  Created by Shun Yu on 10/11/16.
//  Copyright © 2016 Workday. All rights reserved.
//

#import "PNConstants.h"
#import "PNLoggerUtils.h"
#import "PNPropertyUsageMetrics.h"
#import "PNConfigManager.h"

#pragma mark PNPropertyUsageMetricsItem
@interface PNPropertyUsageMetricsItem : NSObject <NSCoding, NSCopying>
@property (strong, nonatomic) NSString *file;
@property (strong, nonatomic) NSString *key;
@end

@implementation PNPropertyUsageMetricsItem
-(id)initWithProperty:(PNProperty *)property
{
    self = [super init];
    if (self)
    {
        self.file = property.pFileInfo.absolutePath;
        self.key = property.key;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.file forKey:KEY_PROPERTY_USAGE_METRICS_ITEM_FILE];
    [aCoder encodeObject:self.key forKey:KEY_PROPERTY_USAGE_METRICS_ITEM_KEY];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.file = [aDecoder decodeObjectForKey:KEY_PROPERTY_USAGE_METRICS_ITEM_FILE];
        self.key = [aDecoder decodeObjectForKey:KEY_PROPERTY_USAGE_METRICS_ITEM_KEY];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    PNPropertyUsageMetricsItem *copy = [[[self class] allocWithZone:zone] init];
    if (copy)
    {
        copy.file = self.file;
        copy.key = self.key;
    }
    return copy;
}

-(BOOL)isEqual:(id)object
{
    PNPropertyUsageMetricsItem *other = object;
    return [self.file isEqual:other.file] && [self.key isEqual:other.key];
}

-(NSUInteger)hash
{
    return [self.file hash] ^ [self.key hash];
}
@end

#pragma mark PNPropertyUsageMetricsItemTally
@interface PNPropertyUsageMetricsItemTally : NSObject
@property (strong, nonatomic) NSString *file;
@property (strong, nonatomic) NSString *key;
@property (nonatomic) NSInteger count;
@end

@implementation PNPropertyUsageMetricsItemTally
-(id)initWithItem:(PNPropertyUsageMetricsItem *)item
{
    self = [super init];
    if (self)
    {
        self.file = item.file;
        self.key = item.key;
        self.count = 0;
    }
    return self;
}

-(void)increment
{
    self.count++;
}

-(NSComparisonResult)compare:(PNPropertyUsageMetricsItemTally *)other
{
    if (self.count < other.count)
    {
        return NSOrderedAscending;
    }
    
    if (self.count > other.count)
    {
        return NSOrderedDescending;
    }
    
    return NSOrderedSame;
}
@end

#pragma mark PNPropertyUsageMetrics
@interface PNPropertyUsageMetrics ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *cache;
@end

@implementation PNPropertyUsageMetrics

- (id)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)getTopVisitedProperties:(NSInteger) top
{
    if (!self.cache) {
        @synchronized (self) {
            if (!self.cache) {
                DDLogInfo(@"calculating cache");
                NSMutableDictionary *index = [[NSMutableDictionary alloc] init];
                for (PNPropertyUsageMetricsItem *item in self.data) {
                    PNPropertyUsageMetricsItemTally *tally = index[item];
                    if (!tally) {
                        tally = [[PNPropertyUsageMetricsItemTally alloc] initWithItem:item];
                        index[item] = tally;
                    }
                    [tally increment];
                }
                
                NSMutableArray *tallies = [[NSMutableArray alloc] initWithArray:[index allValues]];
                [tallies sortUsingSelector:@selector(compare:)];
                
                NSMutableArray *result = [[NSMutableArray alloc] init];
                for (PNPropertyUsageMetricsItemTally *tally in tallies) {
                    [result addObject:@[tally.file, tally.key]];
                }
                
                self.cache = [[NSArray alloc] initWithArray:result];
            }
        }
    }
    return self.cache;
}

- (void)edited:(PNProperty *) property
{
    PNPropertyUsageMetricsItem *item = [[PNPropertyUsageMetricsItem alloc] initWithProperty:property];
    [self.data insertObject:item atIndex:0];
    
    if ([self.data count] > 100) {
        @synchronized (self.data) {
            if ([self.data count] > 100) {
                [self.data removeObjectsInRange:NSMakeRange(100, [self.data count] - 100)];
            }
        }
    }
    
    @synchronized (self) {
        self.cache = nil;
    }
    
    [PNConfigManager save:self];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:KEY_PROPERTY_USAGE_METRICS_DATA];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.data = [aDecoder decodeObjectForKey:KEY_PROPERTY_USAGE_METRICS_DATA];
    }
    return self;
}
@end
