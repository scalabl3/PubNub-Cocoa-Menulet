//
//  PreferencesWindowController.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/12/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "TrafficLight.h"

@interface PreferencesWindowController : NSWindowController

// Preferences Window, Toolbar and Form
@property (weak) IBOutlet NSToolbar *preferencesToolbar;
@property (weak) IBOutlet NSForm *formPubNubPreferences;

@property (weak) IBOutlet TrafficLight *connectedStatusLight;
@property (weak) IBOutlet NSTextField *connectedText;

@property (weak) IBOutlet TrafficLight *lightChannelSubscribed;
@property (weak) IBOutlet TrafficLight *lightPublishKeyValid;
@property (weak) IBOutlet TrafficLight *lightSubscribeKeyValid;
@property (weak) IBOutlet TrafficLight *lightTestSubscribe;
@property (weak) IBOutlet TrafficLight *lightTestPublish;
 
@property (weak) IBOutlet NSTextField *operationsText;

@property (strong) NSString* generatedRandomTestMessage;

- (void)appendOperationsText:(NSString*) text;
- (void)appendOperationsText:(NSString*) text newline:(BOOL)newline;

- (void) subscribeToChannel:(NSString *)channel;
- (void) subscribeToChannel:(NSString *)channel onSuccess:(void (^)())onSuccess;
- (void) publishToChannel:(NSString *)channel message:(NSString*)message onSuccess:(void (^)())onSuccess;


- (IBAction)didChangePubnubChannel:(NSFormCell *)sender;
- (IBAction)didChangePubnubPublishKey:(NSFormCell *)sender;
- (IBAction)didChangePubnubSubscribeKey:(NSFormCell *)sender;

- (void) tidyUpWindowElements;

@end
