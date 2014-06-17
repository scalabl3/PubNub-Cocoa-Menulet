//
//  AppDelegate.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Pubnubians.h"
#import "PopoverMenulet.h"
#import "PopoverController.h"
#import "PreferencesWindowController.h"
#import "PNImports.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, PNDelegate>

@property (strong) Pubnubians* pubnubians;
@property (strong) PNConfiguration* pubnubConfig;

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, strong) PopoverController* popoverViewController;

@property (nonatomic, strong) NSWindowController* preferencesWindowController;

@property (nonatomic, strong) PopoverMenulet* popoverMenulet;
@property (nonatomic, strong) NSStatusItem *statusItem;

// Popover Window Gear Button (to open preferenecs)
@property (weak) IBOutlet NSMenuItem *menuItemPreferences;


// Open Preferences Window from Menu or CMD-,
- (void)showPreferencesWindow;
- (IBAction)menuClickPreferences:(id)sender;


@end

