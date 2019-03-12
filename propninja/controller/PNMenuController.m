//
//  PNMenuDelegate.m
//  propninja
//
//  Created by Shun Yu on 12/20/14.
//  Copyright (c) 2014 Workday. All rights reserved.
//

#import "PNMenuController.h"

@interface PNMenuController ()
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSArray* processes;

@property (weak, nonatomic) PNAppDelegate *appDelegate;
@end

@implementation PNMenuController
- (id)initWithAppDelegate:(PNAppDelegate *)appDelegate
{
    self = [super init];
    if (self)
    {
        self.appDelegate = appDelegate;
        self.statusItem = [self initializeStatusItem];
        self.menu = [self initializeMenu];
    }
    
    return self;
}

- (NSStatusItem *)initializeStatusItem
{
    NSStatusItem *item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    item.highlightMode = YES;
    item.image = [NSImage imageNamed:@"MenuIcon"];
    item.image.template = true;
    item.action = @selector(show:);
    item.target = self;

    return item;
}

- (NSMenu*) initializeMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    menu.delegate = self;
    
    return menu;
}

#pragma mark UI

- (void)show:(id)sender
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}

- (void)showProperties:(id)sender
{
    [self.appDelegate showProperties:self];
}

- (void)showPreferences:(id)sender
{
    [self.appDelegate showPreferences:self];
}

- (void)quit:(id)sender
{
    [self.appDelegate quit:self];
}

#pragma mark - NSMenuDelegate

- (NSInteger)numberOfItemsInMenu:(NSMenu*)menu
{
    return 1 // dividers
         + 3; // items
}

- (BOOL)menu:(NSMenu*)menu updateItem:(NSMenuItem*)item atIndex:(NSInteger)index shouldCancel:(BOOL)shouldCancel
{
    if (index == 0)
    {
        item.title = @"Properties";
        item.keyEquivalent = @"1";
        item.action = @selector(showProperties:);
    }
    else if (index == 1) {
        [menu removeItemAtIndex:index];
        [menu insertItem:[NSMenuItem separatorItem] atIndex:index];
    }
    else if (index == 2)
    {
        item.title = @"Preferences";
        item.keyEquivalent = @"p";
        item.action = @selector(showPreferences:);
    }
    else
    {
        item.title = @"Quit";
        item.keyEquivalent = @"q";
        item.action = @selector(quit:);
    }
    
    item.keyEquivalentModifierMask = NSCommandKeyMask;
    item.target = self;
    item.enabled = YES;
    
    return YES;
}

@end
