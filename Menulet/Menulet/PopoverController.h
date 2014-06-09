//
//  PopoverController.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/4/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol PopoverMenuletDelegate <NSObject>

- (BOOL)isActive;
- (void)menuletClicked;

@end

@interface PopoverController : NSViewController <PopoverMenuletDelegate>

@property (nonatomic, assign, getter = isActive) BOOL active;
@property (nonatomic, strong) NSPopover *popover;
@property (weak) IBOutlet NSButton *preferencesButton;

- (IBAction)didClickPubnubPreferences:(id)sender;

@end
