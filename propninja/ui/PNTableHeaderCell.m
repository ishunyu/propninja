//
//  PNTableHeaderCell.m
//  propninja
//
//  Created by Shun Yu on 1/4/15.
//  Copyright (c) 2015 Workday. All rights reserved.
//

#import "PNTableHeaderCell.h"
#import "NSString+Utilities.h"

@interface PNTableHeaderCell ()
@property (strong, nonatomic) NSMutableDictionary *attributes;
@end

@implementation PNTableHeaderCell
-(id)initWithHeaderCell:(NSTableHeaderCell *)cell
{
    self = [super initTextCell:[cell stringValue]];
    if (self)
    {
        NSAttributedString *attributedString = cell.attributedStringValue;
        
        NSDictionary *attributeDictionary = @{};
        
        if(![NSString isNullOrEmpty:attributedString.string])
            attributeDictionary = [attributedString attributesAtIndex:0 effectiveRange:nil];
        
        self.attributes = [NSMutableDictionary dictionaryWithDictionary:attributeDictionary];
        self.attributes[@"NSFont"] = [NSFont boldSystemFontOfSize:11.0];
    }
    
    return self;
}

- (void)colorBackground:(NSRect)cellFrame
{
    [[NSColor controlHighlightColor] set];
    NSRectFill(cellFrame);
}

- (void)drawTopBorder:(NSRect)cellFrame
{
    [[NSColor controlShadowColor] set];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:NSMakePoint(cellFrame.origin.x, cellFrame.origin.y)];
    [path lineToPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width, cellFrame.origin.y)];
    
    [path stroke];
}

- (void)drawSeparatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSTableHeaderView *headerView = (NSTableHeaderView *)controlView;
    NSTableColumn *column = [[headerView.tableView tableColumns] lastObject];
    
    
    if (self == column.headerCell)
        return;
    
    [[NSColor blackColor] set];
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0,
                                  cellFrame.origin.y + cellFrame.size.height - 1.0)];
    [path lineToPoint:NSMakePoint(cellFrame.origin.x + cellFrame.size.width - 1.0,
                                  cellFrame.origin.y + 2.0)];
    
    [path stroke];
}

- (void)drawText:(NSRect)cellFrame
{
    // move to the right a little
    CGRect rect = CGRectMake(cellFrame.origin.x + 3,
                             cellFrame.origin.y + 2,
                             cellFrame.size.width,
                             cellFrame.size.height - 2);
    
    [[self stringValue] drawInRect:rect withAttributes:self.attributes];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    
    [self colorBackground:cellFrame];
    [self drawTopBorder:cellFrame];
    [self drawSeparatorWithFrame:cellFrame inView:controlView];
    [self drawText:cellFrame];
}
@end
