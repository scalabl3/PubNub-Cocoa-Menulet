//
//  PubnubSettings.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/5/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubnubSettings : NSObject

@property (strong) NSString* channel;
@property (strong) NSString* publishKey;
@property (strong) NSString* subscribeKey;

@end
