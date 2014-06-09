//
//  PopoverMenulet.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/6/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "PopoverMenulet.h"

static void *kActiveChangedKVO = &kActiveChangedKVO;

@implementation PopoverMenulet

@synthesize delegate;

- (void)setDelegate:(id<PopoverMenuletDelegate>)newDelegate
{
   [(NSObject *)newDelegate addObserver:self forKeyPath:@"active" options:NSKeyValueObservingOptionNew context:kActiveChangedKVO];
   delegate = newDelegate;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
#if WITHOUT_IMAGE
   rect = CGRectInset(rect, 2, 2);
   if ([self.delegate isActive]) {
      [[NSColor selectedMenuItemColor] set]; /* blueish */
   } else {
      [[NSColor textColor] set]; /* blackish */
   }
   NSRectFill(rect);
#else
   NSImage *menuletIcon;
   [[NSColor clearColor] set];
   if ([self.delegate isActive]) {
      menuletIcon = [NSImage imageNamed:@"Pubnub Menulet Active"];
   } else {
      menuletIcon = [NSImage imageNamed:@"Pubnub Menulet Inactive"];
   }
   [menuletIcon drawInRect:NSInsetRect(rect, 2, 2) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
#endif
}

- (void)mouseDown:(NSEvent *)event {
   NSLog(@"Mouse down event: %@", event);
   [self.delegate menuletClicked];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   if (context == kActiveChangedKVO) {
      //NSLog(@"%@", change);
      [self setNeedsDisplay:YES];
   }
}


@end
