//
//  PopoverMenulet.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/6/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PopoverController.h"

@interface PopoverMenulet : NSView

@property (nonatomic, weak) id<PopoverMenuletDelegate> delegate;

@end
