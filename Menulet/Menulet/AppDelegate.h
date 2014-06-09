//
//  AppDelegate.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PubnubSettings.h"
#import "PopoverMenulet.h"
#import "PopoverController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong) PubnubSettings* pubnubSettings;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, strong) PopoverMenulet *popoverMenulet;
@property (nonatomic, strong) PopoverController *popoverController;
@property (nonatomic, strong) NSStatusItem *statusItem;

// Popover Window Gear Button (to open preferenecs)
@property (weak) IBOutlet NSMenuItem *menuItemPreferences;

// Preferences Window, Toolbar and Form
@property (strong) IBOutlet NSWindowController *preferencesWindowController;
@property (weak) IBOutlet NSWindow *preferencesWindow;
@property (weak) IBOutlet NSForm *formPubNubPreferences;

// Open Preferences Window from Menu or CMD-,
- (IBAction)menuClickPreferences:(id)sender;

- (IBAction)clickPreferencesToolbarPubnub:(id)sender;

@end

