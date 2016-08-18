//
//  PNPreferencesController.m
//  propninja
//
//  Created by Shun Yu on 12/22/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "DDHotKeyCenter.h"
#import "DDHotKeyTextField.h"

#import "PNLoggerUtils.h"
#import "PNPathUtils.h"

#import "PNPropertyFileInfoConfig.h"
#import "PNHotKeyManager.h"

#import "PNTableView.h"

#import "PNPreferencesWindowController.h"

@interface PNPreferencesWindowController()
@property (weak) IBOutlet PNTableView *tableView;
@property (weak) IBOutlet DDHotKeyTextField *hotKeyTextField;
@property (strong, nonatomic) PNPropertyFileInfoConfig *configuration;

@property (nonatomic) BOOL deleteBackward;
@end

@implementation PNPreferencesWindowController

- (void)windowDidLoad
{
    [self.tableView replaceHeaders];
    [self.hotKeyTextField setHotKey:[[PNHotKeyManager sharedInstance] getDDHotKey]];
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    self.configuration = [[PNPropertyFileInfoConfig alloc] init];
    [self.tableView reloadData];
}

- (void)saveAndReload
{
    [self.configuration saveToUserDefaults];
    [self.tableView reloadData];
}

#pragma mark NSControl
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (control == self.tableView)
    {
        if (commandSelector == @selector(deleteBackward:))
        {
            self.deleteBackward = YES;
            return NO;
        }
        
        if (commandSelector == @selector(insertTab:))
        {
            NSTextFieldCell *cell = self.tableView.selectedCell;
            NSText *text = [self.window fieldEditor:YES forObject:cell];
            
            [text setSelectedRange:NSMakeRange(cell.stringValue.length, 0)];
            
            return YES;
        }
    
        
    }
    
    return NO;
}

#pragma mark NSTextFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj
{
    if (obj.object == self.tableView) {
        long col = self.tableView.editedColumn;
        NSTableColumn *column = self.tableView.tableColumns[col];
        NSTextFieldCell *cell = self.tableView.selectedCell;
        
        if ([column.identifier isEqualToString:@"path"] && !self.deleteBackward)
        {
            NSString *old = cell.stringValue;
            NSString *autocomplete = [PNPathUtils autocomplete:old];
            
            cell.stringValue = autocomplete;
            
            NSText *cellText = [self.window fieldEditor:YES forObject:cell];
            
            if (old.length < autocomplete.length)
                [cellText setSelectedRange:NSMakeRange(old.length, autocomplete.length - old.length)];
        }
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    if (obj.object == self.hotKeyTextField) {
        DDLogInfo(@"hello");
        
        DDHotKey *ddHotKey = self.hotKeyTextField.hotKey;
        [[PNHotKeyManager sharedInstance] setAndRegisterHotKeyWithModiferFlag:ddHotKey.modifierFlags keyCode:ddHotKey.keyCode];
    }
    
    if (obj.object == self.tableView) {
        long row = self.tableView.editedRow;
        long col = self.tableView.editedColumn;
        
        if (self.configuration.count <= row)
            return;
        
        PNPropertyFileInfo *old = [self.configuration pFileInfoForIndex:row];
        BOOL enabled = old.enabled;
        NSString *label = old.label;
        NSString *path = old.path;
        
        switch (col) {
            case 0:
                enabled = [self.tableView.cell boolValue];
                break;
                
            case 1:
                label = [self.tableView stringValue];
                break;
                
            case 2:
                path = [self.tableView stringValue];
                break;
                
            default:
                return;
        }
        
        PNPropertyFileInfo *new = [[PNPropertyFileInfo alloc] initWithLabel:label path:path enabled:enabled];
        
        [self.configuration setPFileInfo:new index:row];
        [self saveAndReload];
    }
}

#pragma mark NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.configuration.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    PNPropertyFileInfo *propertyFile = [self.configuration pFileInfoForIndex:row];
    
    if ([tableColumn.identifier isEqualToString:@"enabled"])
        return @(propertyFile.enabled);
    
    if ([tableColumn.identifier isEqualToString:@"tag"])
        return propertyFile.label;
    
    return propertyFile.path;
}

#pragma deleteBackward
- (BOOL)deleteBackward
{
    BOOL old = _deleteBackward;
    _deleteBackward = NO;
    
    return old;
}

#pragma mark Nib
- (IBAction)buttonCellClicked:(id)sender {

    NSButtonCell *cell = self.tableView.selectedCell;
    BOOL enabled = cell.state == NSOnState;

    long row = self.tableView.selectedRow;
    [self.configuration pFileInfoForIndex:row].enabled = enabled;

    [self saveAndReload];
}

- (IBAction)addButtonClicked:(NSButton *)sender
{
    [self.configuration addEmptyPFileInfo];
    [self saveAndReload];
}

- (IBAction)removeButtonClicked:(NSButton *)sender
{
    [self.configuration removePFileInfoForIndex:self.tableView.selectedRow];
    [self saveAndReload];
}
@end
