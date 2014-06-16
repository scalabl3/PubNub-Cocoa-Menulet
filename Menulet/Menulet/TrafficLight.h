//
//  TrafficLight.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/12/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TrafficLight : NSImageView

@property (strong) NSString* stateColor;

- (void) turnRed;
- (void) turnGreen;
- (void) turnYellow;
- (void) turnGrey;

@end
