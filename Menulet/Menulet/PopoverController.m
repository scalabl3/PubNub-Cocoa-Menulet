//
//  PopoverController.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "PopoverController.h"
#import "AppDelegate.h"
#import "PopoverMenulet.h"
#import "PopoverController.h"


@implementation PopoverController

@synthesize active;
@synthesize popover;
@synthesize preferencesButton;

- (void)_setupPopover
{
   if (!self.popover) {
      self.popover = [[NSPopover alloc] init];
      self.popover.contentViewController = [[PopoverController alloc] init];
      self.popover.contentSize = (CGSize){330, 660};
   }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)menuletClicked
{
   NSLog(@"Menulet clicked");   
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
   self.active = ! self.active;
   if (self.active) {
      [self _setupPopover];
      [self.popover showRelativeToRect:[appDelegate.popoverMenulet frame]
                                ofView:appDelegate.popoverMenulet
                         preferredEdge:NSMinYEdge];
   } else {
      [self.popover performClose:self];
   }
}

- (IBAction)didClickPubnubPreferences:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [appDelegate showPreferencesWindow];
}
@end
