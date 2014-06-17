//
//  Pubnubians.h
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/17/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pubnubians : NSObject

+(NSMutableDictionary*) observedChannels;

+ (void) observeChannel:(NSString*)channel onReceive:(void (^)())onReceive;

@property (strong) NSString* channel;
@property (strong) NSString* publishKey;
@property (strong) NSString* subscribeKey;

@end
