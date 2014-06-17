//
//  Pubnubians.m
//  Menulet
//
//  Created by Jasdeep Jaitla on 6/17/14.
//  Copyright (c) 2014 Jasdeep Jaitla. All rights reserved.
//

#import "Pubnubians.h"

@implementation Pubnubians

+(NSMutableDictionary*) observedChannels
{
   static NSMutableDictionary* fooDict = nil;
   
   static dispatch_once_t oncePredicate;
   
   dispatch_once(&oncePredicate, ^{
      fooDict = [[NSMutableDictionary alloc] init];
   });
   
   return fooDict;
}

@synthesize channel;
@synthesize publishKey;
@synthesize subscribeKey;

+ (void) observeChannel:(NSString*)channel onReceive:(void (^)())onReceive
{
   
}


@end
