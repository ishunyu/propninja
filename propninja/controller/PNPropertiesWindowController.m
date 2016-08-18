//
//  PNWindow.m
//  propninja
//
//  Created by Shun Yu on 12/13/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"

#import "PNPropertyFileInfoConfig.h"
#import "PNService.h"

#import "PNPropertiesTableCellView.h"
#import "PNPropertiesTableRowView.h"
#import "PNPropertiesTableView.h"
#import "PNProperty.h"

#import "PNPropertiesWindowController.h"

@interface PNPropertiesWindowController()

@property (weak, nonatomic) PNAppDelegate *appDelegate;

@property (weak) IBOutlet NSTextField *searchBox;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (weak) IBOutlet PNPropertiesTableView *tableView;

@property (strong, nonatomic) PNService *service;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *views;

@property (nonatomic) BOOL mouseDown;
@property (nonatomic) NSPoint mouseDownOrigin;
@property (nonatomic) NSPoint mouseDownPoint;
@end

@implementation PNPropertiesWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName appDelegate:(PNAppDelegate *)appDelegate
{
    self = [super initWithWindowNibName:windowNibName owner:self];
    if (self)
    {
        self.appDelegate = appDelegate;
        self.service = [[PNService alloc] init];
    }
    
    return self;
}

- (NSArray *)createTableCellViews:(NSArray *)properties
{
    NSMutableArray *cellViews = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < properties.count; i++)
    {
        PNProperty *property = properties[i];
        PNPropertiesTableCellView *cellView = [self createTableCellViewFromNib];
        
        [cellView populate:self.tableView index:i
                  property:property
         propertyFileLabel:property.pFileInfo.label];
        [cellViews addObject:cellView];
    }
    
    return [NSArray arrayWithArray:cellViews];
}

- (PNPropertiesTableCellView *)createTableCellViewFromNib
{
    static NSString *nibName = @"PNPropertiesTableCellView";
    NSArray *nibViews;
    [[NSBundle mainBundle] loadNibNamed:nibName owner:self.tableView topLevelObjects:&nibViews];
    for (NSView *view in nibViews)
    {
        if ([[view class] isSubclassOfClass:[NSTableCellView class]])
        {
            return (PNPropertiesTableCellView *)view;
        }
    }
    
    DDLogError(@"error creating %@", [PNPropertiesTableCellView class]);
    return nil;
}

- (void)refreshData
{
    self.views = [self createTableCellViews:self.data];
    [self.tableView reloadData];
}

#pragma mark - NSWindowDelegate
- (void)windowDidResignKey:(NSNotification *)notification
{
    [[NSApplication sharedApplication] hide:self];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [self.service stop];
    self.service = nil;
}

#pragma mark Search
- (void)search
{
    NSString *search = [self.searchBox stringValue];
    NSArray *data = [self.service searchProperties:search];
    
    if (data)
    {
        self.data = data;
        [self refreshData];
    }
}

#pragma mark Commands
- (BOOL)moveUpCommand:(NSControl *)control
{
    if (control == self.searchBox && self.tableView.numberOfRows)
    {
        [self.scrollView becomeFirstResponder];
        [self.tableView selectLastRow];
        return YES;
    }
    else if (control == self.tableView)
    {
        [self.searchBox becomeFirstResponder];
        return YES;
    }
    
    return NO;
}

- (BOOL)moveDownCommand:(NSControl *)control
{
    if (control == self.searchBox  && self.tableView.numberOfRows)
    {
        [self.scrollView becomeFirstResponder];
        [self.tableView selectFirstRow];
        return YES;
    }
    else if (control == self.tableView)
    {
        [self.searchBox becomeFirstResponder];
        return YES;
    }
    
    return NO;
}

- (BOOL)deleteBackwardCommand
{
    [self.searchBox becomeFirstResponder];
    
    NSText *editor = [self.window fieldEditor:YES forObject:self.searchBox];
    
    [editor setSelectedRange:NSMakeRange(self.searchBox.stringValue.length, 0)];
    [editor deleteBackward:self];
    
    return YES;
}

- (BOOL)cancelOperationCommand:(NSControl *)control
{
    if (control == self.tableView || self.tableView.selectedCell)
    {
        [self.tableView selectNone];
        [self.tableView resignFirstResponder];
        [self.searchBox becomeFirstResponder];
        return YES;
    }
    
    [[NSApplication sharedApplication] hide:self];
    
    return YES;
}

#pragma mark NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if (notification.object == self.searchBox)
    {
        [self search];
        return;
    }
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(moveUp:))
        return [self moveUpCommand:control];
    
    if(commandSelector == @selector(moveDown:))
        return [self moveDownCommand:control];

    if (commandSelector == @selector(deleteBackward:) && control == self.tableView)
        return [self deleteBackwardCommand];
    
    if (commandSelector == @selector(cancelOperation:))
        return [self cancelOperationCommand:control];
    
    DDLogDebug(@"PNPropertiesController %@ %@",control, NSStringFromSelector(commandSelector));

    return NO;
}

#pragma mark PNPropertiesTableViewDelegate
- (void)propertyDidChange:(PNPropertiesTableCellView *)cell
{
    DDLogVerbose(@"propertyDidChange index:%ld", cell.index);
    
    PNProperty *oldProperty = (PNProperty *)self.data[cell.index];
    NSString *oldValue = oldProperty.value;
    NSString *newValue = cell.valueField.stringValue;
    
    if (![oldValue isEqualToString:newValue])
    {
        PNProperty *newProperty = [[PNProperty alloc] initWithProperty:oldProperty value:newValue];
        
        [self.service setProperty:newProperty];
        [self search];
        
        for (NSUInteger i = 0; i <= self.data.count; i++)
        {
            PNProperty *property = self.data[i];
            
            if ([property.pFileInfo isEqualTo:oldProperty.pFileInfo] && [property.key isEqualToString:oldProperty.key]) {
                [self.window makeFirstResponder:self.tableView];
                [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
                return;
            }
        }
        
        [self.window makeFirstResponder:self.searchBox];
    }
}

- (void)refresh
{
    DDLogVerbose(@"refresh");
    
    [self refreshData];
    [self.searchBox becomeFirstResponder];
}

- (void)resignTableView:(PNPropertiesTableView *)tableView;
{
    DDLogVerbose(@"resignTableView");
    
    [tableView resignFirstResponder];
    [self.searchBox becomeFirstResponder];
}

#pragma mark NSTableViewDelegate
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (row < 0 || self.views.count <= row)
        return nil;
    
    return self.views[row];
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    return [[PNPropertiesTableRowView alloc] init];
}

#pragma mark NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.data.count;
}

#pragma mark NSWindow

- (void)mouseDown:(NSEvent *)theEvent
{
    self.mouseDown = YES;
    NSPoint point = [theEvent locationInWindow];
    NSRect rect = [self.window convertRectToScreen:NSMakeRect(point.x, point.y, 0.0f, 0.0f)];
    self.mouseDownOrigin = self.window.frame.origin;
    self.mouseDownPoint = rect.origin;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (self.mouseDown)
    {
        NSPoint point = [theEvent locationInWindow];
        NSRect rect = [self.window convertRectToScreen:NSMakeRect(point.x, point.y, 0.0f, 0.0f)];
        NSPoint screenPoint = rect.origin;
        
        CGFloat deltaX = screenPoint.x - self.mouseDownPoint.x;
        CGFloat deltaY = screenPoint.y - self.mouseDownPoint.y;
        
        [self.window setFrameOrigin:NSMakePoint(self.mouseDownOrigin.x + deltaX, self.mouseDownOrigin.y + deltaY)];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    self.mouseDown = NO;
}

@end
