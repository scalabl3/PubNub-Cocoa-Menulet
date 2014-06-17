//
//  AppDelegate.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize pubnubConfig;

@synthesize popoverMenulet;
@synthesize statusItem;
@synthesize pubnubians;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [PubNub setDelegate:self];
    //[self updatePubnubConnection];
    [self setupUserDefaults];
    [self setupStatusBarIcon];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

#pragma Setup UserDefaults
- (void)setupUserDefaults
{
    // Create empty values for User Preferences
    NSMutableDictionary* defaultPrefs = [[NSMutableDictionary alloc] init];
    defaultPrefs[@"pubnubChannel"] = @"";
    defaultPrefs[@"pubnubPublishKey"] = @"";
    defaultPrefs[@"pubnubSubscribeKey"] = @"";
    defaultPrefs[@"pubnubPublishKeyValid"] = [NSNumber numberWithBool:NO];
    defaultPrefs[@"pubnubSubscribeKeyValid"] = [NSNumber numberWithBool:NO];
    
    NSDictionary* dp = [defaultPrefs copy];
    
    // Initialize UserDefaults with empty User Preferences (won't overwrite existing values)
    [[NSUserDefaults standardUserDefaults] registerDefaults:dp];
    
    pubnubians.channel = [[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubChannel"];
    pubnubians.publishKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubPublishKey"];
    pubnubians.subscribeKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubSubscribeKey"];
    
    self.preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    self.popoverViewController = [[PopoverController alloc] init];
    

}

#pragma StatusBarSetup

- (void)setupStatusBarIcon
{
    // Setup Menulet Icon (NSStatusBar systemStatusBar)
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:thickness];
    
    // Assign Controller for Menulet Popover Window and delegate
    self.popoverMenulet = [[PopoverMenulet alloc] initWithFrame:(NSRect){.size={thickness, thickness}}]; /* square item */
    self.popoverMenulet.delegate = self.popoverViewController;
    [self.statusItem setView:self.popoverMenulet];
    [self.statusItem setHighlightMode:NO]; // Don't show blue highlight when clicked on

}

#pragma Open Preferences Window

// Open Preferences Window
- (void) showPreferencesWindow
{
    NSLog(@"Show the Window man");
    [self.preferencesWindowController showWindow:nil];
}

// Open Preferences Window from Menu or CMD-,
- (IBAction)menuClickPreferences:(id)sender
{
    [self showPreferencesWindow];
}

@end

