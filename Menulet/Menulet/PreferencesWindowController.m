//
//  PreferencesController.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/12/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

@synthesize preferencesToolbar;

@synthesize generatedRandomTestMessage;
@synthesize operationsText;

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        generatedRandomTestMessage = [NSString stringWithFormat:@"Menulet Test - %@", [[NSUUID UUID] UUIDString]];
        
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self tidyUpWindowElements];
    
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:@"yo" withBlock:^(PNMessage * msg) {
        NSLog(@"Message Received");
    }];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pubnubPublishKeyValid"]) {
        [self.lightPublishKeyValid turnGreen];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pubnubSubscribeKeyValid"]) {
        [self.lightSubscribeKeyValid turnGreen];
    }

}

- (void) tidyUpWindowElements
{

    // Initialize Preferences Window Controller
    [preferencesToolbar.items[0] setEnabled:YES];
    [preferencesToolbar setSelectedItemIdentifier: @"pubnub"];
    
    // PubNub Preferences form Aesthetics
    // Auto-resize-cells is disabled, and title size fixed via the following
    [self.formPubNubPreferences setTitleAlignment:NSRightTextAlignment];
    for (NSFormCell* c in _formPubNubPreferences.cells) {
        [c setTitleWidth:80.0];
    }
}


- (void) appendOperationsText:(NSString*) text newline:(BOOL)newline {
    NSMutableString* ops = [NSMutableString stringWithString:[operationsText stringValue]];
    
    [ops appendString:text];
    if (newline) {
        [ops appendString:@"\n"];
    }
    [operationsText setStringValue:[ops copy]];
}

- (void) appendOperationsText:(NSString*) text {
    [self appendOperationsText:text newline:false];
}

#pragma PubNub Message Handling


- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
    
    NSString* messageValue = [message message];
    
    if ([message.channel.name isEqualToString:@"test_menulet"]) {
        
        [self appendOperationsText:@"Received message on test_menulet --" newline:true];
        [self appendOperationsText:[NSString stringWithFormat:@"   channel: %@", message.channel.name] newline:true];
        [self appendOperationsText:[NSString stringWithFormat:@"   message: %@", [message message]] newline:true];
        if ([messageValue isEqualToString:generatedRandomTestMessage]) {
            
            // generate a new test message
            generatedRandomTestMessage = [NSString stringWithFormat:@"Menulet Test - %@", [[NSUUID UUID] UUIDString]];
            [self.lightPublishKeyValid turnGreen];
            [self.lightSubscribeKeyValid turnGreen];
            [self.lightTestPublish turnGreen];
            [self.lightTestSubscribe turnGreen];
        }
    } else if ([message.channel.name isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"pubnubChannel"]]){
        // call your handler
    }
    else {
        NSLog(@"Received a message on unhandled subscribed channel....");
        NSLog(@"   channel: %@", message.channel.name);
        NSLog(@"   message: %@", [message message]);
    }
    
    PNLog(PNLogGeneralLevel, self, @"PubNub client received message: %@", message);
}

- (IBAction)didClickTestConnection:(id)sender {
    
    [self.lightTestSubscribe turnYellow];
    [self.lightTestPublish turnYellow];
    
    [self subscribeToChannel:@"test_menulet" onSuccess:^{
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pubnubSubscribeKeyValid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.lightSubscribeKeyValid turnGreen];
        [self.lightTestSubscribe turnGreen];
        [self publishToChannel:@"test_menulet" message:generatedRandomTestMessage onSuccess:^{
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pubnubPublishKeyValid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.lightPublishKeyValid turnGreen];
            [self.lightTestPublish turnGreen];
        }];
    }];
}

- (IBAction)didChangePubnubChannel:(NSFormCell *)sender {
    
    NSString* nc = [[[self formPubNubPreferences] cellAtIndex:0] stringValue];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    if (![appDelegate.pubnubSettings.channel isEqualToString:nc]) {
        appDelegate.pubnubSettings.channel = [nc copy];
        [self.lightChannelSubscribed turnYellow];
        NSLog(@"User changed channel to %@", nc);
        [self updatePubnubConnection];
    }
}

- (IBAction)didChangePubnubPublishKey:(NSFormCell *)sender {
    
    NSString* npk = [[[self formPubNubPreferences] cellAtIndex:1] stringValue];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    if (![appDelegate.pubnubSettings.publishKey isEqualToString:npk]) {
        NSLog(@"User changed publish key to %@", npk);
        appDelegate.pubnubSettings.publishKey = npk;
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"pubnubPublishKeyValid"];
        [self.lightPublishKeyValid turnYellow];
        [self updatePubnubConnection];
    }
}

- (IBAction)didChangePubnubSubscribeKey:(NSFormCell *)sender {
    
    NSString* nsk = [[[self formPubNubPreferences] cellAtIndex:2] stringValue];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    if (![appDelegate.pubnubSettings.subscribeKey isEqualToString:nsk]) {
        NSLog(@"User changed subscribe key to %@", [[[self formPubNubPreferences] cellAtIndex:2] stringValue]);
        appDelegate.pubnubSettings.subscribeKey = nsk;
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"pubnubSubscribeKeyValid"];
        [self.lightSubscribeKeyValid turnYellow];
        [self updatePubnubConnection];
    }
}

- (void) testPubNubConnection {
    
    [self.lightTestSubscribe turnYellow];
    [self.lightTestPublish turnYellow];
    
    [self subscribeToChannel:@"test_menulet" onSuccess:^{
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pubnubSubscribeKeyValid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.lightSubscribeKeyValid turnGreen];
        [self.lightTestSubscribe turnGreen];
        [self publishToChannel:@"test_menulet" message:generatedRandomTestMessage onSuccess:^{
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"pubnubPublishKeyValid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.lightPublishKeyValid turnGreen];
            [self.lightTestPublish turnGreen];
        }];
    }];
}

// Preferences are bound directly to NSUserDefaults, this is for reconnecting to PubNub
- (void)updatePubnubConnection {
    operationsText.stringValue = @"";
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    // Setup PubNub Configuration with Stored Preferences values
    [PubNub setupWithConfiguration:[PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                                publishKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubPublishKey"]
                                                              subscribeKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubSubscribeKey"]
                                                                 secretKey:@""]
                       andDelegate:appDelegate];
    
    
    // If not connected to PubNub, connect now (usually on app start)
    if (![[PubNub sharedInstance] isConnected]) {
        
        [self appendOperationsText:@"Connecting to PubNub... "];
        
        
        [PubNub connectWithSuccessBlock:^(NSString * success) {
            NSLog(@"Connected to PubNub");
            
            [self appendOperationsText:@"done!" newline:true];
            [self.connectedStatusLight turnGreen];
            [self.connectedText setStringValue:@"Connected"];
            
            [self testPubNubConnection];
            
            
            // If specified, subscribe to the User specified channel
            NSString *userChannel = [[NSUserDefaults standardUserDefaults] stringForKey:@"pubnubChannel"];
            
            if (userChannel != nil && ![userChannel isEqualToString:@""]) {
                [self subscribeToChannel:userChannel onSuccess:^{
                    [self.lightChannelSubscribed turnGreen];
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pubnubPublishKeyValid"]) {
                        [self.lightPublishKeyValid turnGreen];
                    }
                    else {
                        [self.lightPublishKeyValid turnYellow];
                    }
                    
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"pubnubSubscribeKeyValid"]) {
                        [self.lightSubscribeKeyValid turnGreen];
                    }
                    else {
                        [self.lightSubscribeKeyValid turnYellow];
                    }
                }];
            }
        } errorBlock:^(PNError * error) {
            NSLog(@"Connection Error - PubNub - %@", error);
            
            [self appendOperationsText:@"error!\n"];
            [self.connectedStatusLight turnRed];
            [self.connectedText setStringValue:@"Not Connected"];
        }];
    }
    else {
        
        [self appendOperationsText:@"Connecting to PubNub... done!" newline: true];
        
        // Subscribe the channel defined
        [self subscribeToChannel:[[self.formPubNubPreferences cellAtIndex:0] stringValue] onSuccess:^{
            [self.lightSubscribeKeyValid turnYellow];
        }];
    }
}

- (void) subscribeToChannel:(NSString *)channel {
    [self subscribeToChannel:channel onSuccess:nil];
}

- (void) subscribeToChannel:(NSString *)channel onSuccess:(void (^)())onSuccess {
    
    // Define a channel
    PNChannel *pnChannel = [PNChannel channelWithName:channel shouldObservePresence:NO];
    
    // Subscribe on the channel
    [PubNub subscribeOnChannel:pnChannel withCompletionHandlingBlock:^(PNSubscriptionProcessState state, NSArray *a, PNError *e) {
        switch(state) {
            case PNSubscriptionProcessWillRestoreState:
                break;
            case PNSubscriptionProcessRestoredState:
                break;
            case PNSubscriptionProcessSubscribedState:
                [self appendOperationsText:[NSString stringWithFormat:@"Subscribing to \"%@\" channel... done!", channel] newline:true];
                if (onSuccess) {
                    onSuccess();
                }
                break;
            case PNSubscriptionProcessNotSubscribedState:
                [self appendOperationsText:[NSString stringWithFormat:@"Subscribing to \"%@\" channel... error!", channel] newline:true];
                [self appendOperationsText:[NSString stringWithFormat:@"     Error: \"Invalid Subscribe Key\""] newline:true];
                [self.lightSubscribeKeyValid turnRed];
                break;
        }
    }];
}

- (void) publishToChannel:(NSString*)channel message:(NSString*)message onSuccess:(void (^)())onSuccess {
    
    // Define a channel
    PNChannel *pnChannel = [PNChannel channelWithName:channel shouldObservePresence:NO];
    
    // Publish on the channel
    [self appendOperationsText:[NSString stringWithFormat:@"Publishing to \"%@\" channel...", channel] newline:true];
    [PubNub sendMessage:message toChannel:pnChannel withCompletionBlock:^(PNMessageState state, id data) {
        
        PNError* e = nil;
        
        switch (state) {
            case PNMessageSending:
                //[self appendOperationsText:@"sending... " newline:false];
                break;
            case PNMessageSendingError:
                NSLog(@"Error Sending Message: %@", message);
                [self appendOperationsText:@"error!" newline:true];
                e = (PNError *)data;
                [self appendOperationsText:[[NSMutableString stringWithFormat: @"   Error: %@",[e localizedDescription]] copy] newline:true];
                [self appendOperationsText:[[NSMutableString stringWithFormat: @"   Error: %@",[e localizedFailureReason]] copy] newline:true];
                
                break;
            case PNMessageSent:
                //[self appendOperationsText:@"done!" newline:true];
                if (onSuccess) {
                    onSuccess();
                }
                break;
        }
    }];
}



@end

//    NSString* c = [[self.formPubNubPreferences cellAtIndex:0] stringValue];
//    NSString* pk = [[self.formPubNubPreferences cellAtIndex:1] stringValue];
//    NSString* sk = [[self.formPubNubPreferences cellAtIndex:2] stringValue];
