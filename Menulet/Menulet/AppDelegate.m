//
//  AppDelegate.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "AppDelegate.h"
#import "PopoverMenulet.h"
#import "PopoverController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize popoverMenulet;
@synthesize popoverController;
@synthesize statusItem;

@synthesize preferencesWindowController;
@synthesize preferencesWindow;
@synthesize pubnubSettings;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

   // Setup Menulet Icon (NSStatusBar systemStatusBar)
   CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
   self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:thickness];
   
   // Assign Controller for Menulet Popover Window and delegate
   self.popoverMenulet = [[PopoverMenulet alloc] initWithFrame:(NSRect){.size={thickness, thickness}}]; /* square item */
   self.popoverController = [[PopoverController alloc] init];
   self.popoverMenulet.delegate = self.popoverController;
   [self.statusItem setView:self.popoverMenulet];
   [self.statusItem setHighlightMode:NO]; // Don't show blue highlight when clicked on
   
   // Initialize Preferences Window Controller
   preferencesWindowController = [[NSWindowController alloc] initWithWindow:preferencesWindow];

   NSToolbar* preferencesToolbar = [preferencesWindow toolbar];
   [preferencesToolbar.items[0] setEnabled:YES];
   [preferencesToolbar setSelectedItemIdentifier: @"pubnub"];
   
   
   // PubNub Preferences form Aesthetics
   // Auto-resize-cells is disabled, and title size fixed via the following
   [self.formPubNubPreferences setTitleAlignment:NSRightTextAlignment];
   for (NSFormCell* c in _formPubNubPreferences.cells) {
      [c setTitleWidth:80.0];
   }

   // Create empty values for User Preferences
   NSMutableDictionary* defaultPrefs = [[NSMutableDictionary alloc] init];
   defaultPrefs[@"pubnubChannel"] = @"";
   defaultPrefs[@"pubnubPublishKey"] = @"";
   defaultPrefs[@"pubnubSubscribeKey"] = @"";
   
   NSDictionary* dp = [defaultPrefs copy];
   
   // Initialize UserDefaults with empty User Preferences (won't overwrite existing values)
   [ [NSUserDefaults standardUserDefaults] registerDefaults:dp];
   
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
   // Insert code here to tear down your application
}

// Open Preferences Window from Menu or CMD-,
- (IBAction)menuClickPreferences:(id)sender {
   [preferencesWindowController showWindow:nil];
}

- (IBAction)clickPreferencesToolbarPubnub:(id)sender {
   // do things here?
}
@end
