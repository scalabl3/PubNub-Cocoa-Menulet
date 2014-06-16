//
//  TrafficLight.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/12/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "TrafficLight.h"

@implementation TrafficLight

@synthesize stateColor;

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (self.stateColor == nil || [self.stateColor isEqualToString:@""]){
            self.stateColor = @"red";
        }
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void) turnRed {
    self.stateColor = @"red";
    [self setImage:[NSImage imageNamed:@"Traffic Red"]];
}
- (void) turnGreen {
    self.stateColor = @"green";
    [self setImage:[NSImage imageNamed:@"Traffic Green"]];
}
- (void) turnYellow {
    self.stateColor = @"yellow";
    [self setImage:[NSImage imageNamed:@"Traffic Yellow"]];
}
- (void) turnGrey {
    self.stateColor = @"grey";
    [self setImage:[NSImage imageNamed:@"Traffic Grey"]];
}
@end
