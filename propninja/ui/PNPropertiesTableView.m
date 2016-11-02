//
//  PNTableView.m
//  propninja
//
//  Created by Shun Yu on 12/14/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNLoggerUtils.h"

#import "PNTableHeaderCell.h"
#import "PNPropertiesTableCellView.h"
#import "PNPropertiesTableView.h"

@interface PNPropertiesTableView ()

@end

@implementation PNPropertiesTableView

- (NSUInteger)currentIndex
{
    NSIndexSet *indexSet = self.selectedRowIndexes;
    if (indexSet.count == 0)
    {
        PNPropertiesTableCellView *cell = [self cellFromFirstResponder];
        if (cell)
            return cell.index;
    }
    
    return indexSet.firstIndex;
}

#pragma mark Data

- (PNPropertiesTableCellView *)cellFromNotification:(NSNotification *)obj
{
    NSTextField *textField = (NSTextField *)obj.object;
    PNPropertiesTableCellView *cell = (PNPropertiesTableCellView *)textField.superview;
    
    return cell;
}

- (PNPropertiesTableCellView *)cellFromFirstResponder
{
    NSView *view = (NSView *) self.window.firstResponder;
    if (!view)
        return nil;
    NSView *_view = view.superview;
    if (!_view)
        return nil;
    NSView *__view = _view.superview;
    if (!__view)
        return nil;
    
    PNPropertiesTableCellView *cell = (PNPropertiesTableCellView *) __view.superview;
    
    return cell;
}

#pragma mark Row Selection
/*
 Scrolls to the selected rows.
 Make sure to also let indexes.count == 0 through to allow deselect from any row.
 */
-(void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend
{
    NSUInteger index = indexes.firstIndex;
    
    DDLogVerbose(@"selectRow index:%lu", index);
    
    if (indexes.count == 0 || index < self.numberOfRows)
    {
        [self scrollRowToVisible:index];
        [super selectRowIndexes:indexes byExtendingSelection:extend];
    }
}

#pragma mark Row Selection Helpers
- (void)moveUp
{
    unsigned long currentIndex = [self currentIndex];
    
    DDLogVerbose(@"moveUp index:%lu", currentIndex);
    
    if (currentIndex == 0)
    {
        [self.delegate control:self textView:nil doCommandBySelector:@selector(cancelOperation:)];
    }
    else if(currentIndex < self.numberOfRows)
    {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:currentIndex - 1] byExtendingSelection:NO];
    }
    else
    {
        [self selectLastRow];
    }
}

-(void)moveDown
{
    unsigned long currentIndex = [self currentIndex];
    
    DDLogVerbose(@"moveDown index:%lu", currentIndex);

    if (currentIndex == [self lastRow])
    {
        [self.delegate control:self textView:nil doCommandBySelector:@selector(cancelOperation:)];
    }
    else if (currentIndex < self.numberOfRows)
    {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:currentIndex + 1] byExtendingSelection:NO];
    }
    else
    {
        [self selectFirstRow];
    }
}

- (void)selectFirstRow
{
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (void)selectLastRow
{
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:[self lastRow]] byExtendingSelection:NO];
}

- (void)selectNone
{
    [self selectRowIndexes:[NSIndexSet indexSet] byExtendingSelection:NO];
}


- (NSUInteger)lastRow
{
    return self.numberOfRows - 1;
}


#pragma mark NSTextFieldDelegate
// This is for the valueField in PNPropertiesTableCellView
- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(cancelOperation:))
    {
        PNPropertiesTableCellView *cellView = [self cellFromFirstResponder];
        [cellView deselect];
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:cellView.index] byExtendingSelection:NO];
    }
    
    DDLogDebug(@"doCommandBySelector %@", NSStringFromSelector(commandSelector));
    
    return NO;
}

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
    DDLogInfo(@"controlTextDidEndEditing");
    
    PNPropertiesTableCellView *cell;
    cell = [self cellFromNotification:obj];
    
    [(id<PNPropertiesTableViewDelegate>)self.delegate cellDidChange:cell];
}

#pragma mark PNPropertiesTableCellViewDelegate
- (void)cellHeightDidChange:(PNPropertiesTableCellView *)cellView
{
    [self noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndex:cellView.index]];
}

#pragma mark KeyDown
- (void)keyDown:(NSEvent *)theEvent
{
    static NSEventModifierFlags keys = NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask;
    NSEventModifierFlags modifierFlags = theEvent.modifierFlags & keys;
    
    if (theEvent.keyCode == 126 && modifierFlags == 0) // up
    {
        [self moveUp];
        return;
    }
    
    if (theEvent.keyCode == 125 && modifierFlags ==0) // down
    {
        [self moveDown];
        return;
    }
    
    if (theEvent.keyCode == 51 && modifierFlags == 0) // delete
    {
        [self.delegate control:self textView:nil doCommandBySelector:@selector(deleteBackward:)];
        return;
    }
    
    if (theEvent.keyCode == 53 && modifierFlags == 0) // esc
    {
        [self.delegate control:self textView:nil doCommandBySelector:@selector(cancelOperation:)];
        return;
    }
    
    DDLogInfo(@"keyDown keyCode: %d modiferFlags: %lu", theEvent.keyCode, modifierFlags);
    [super keyDown:theEvent];
}

@end
