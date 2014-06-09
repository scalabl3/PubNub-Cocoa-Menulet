//
//  PNPresenceEvent.m
//  pubnub
//
//  Object which is used to describe concrete
//  presence event which arrived from PubNub
//  services.
//
//
//  Created by Sergey Mamontov.
//
//


#import "PNPresenceEvent+Protected.h"
#import "PNClient+Protected.h"
#import "PNClient.h"


// ARC check
#if !__has_feature(objc_arc)
#error PubNub presence event must be built with ARC.
// You can turn on ARC for only PubNub files by adding '-fobjc-arc' to the build phase for each of its files.
#endif


#pragma mark Class forward

@class PNClient;


#pragma mark Structures

struct PNPresenceEventDataKeysStruct PNPresenceEventDataKeys = {
    .action = @"action",
    .timestamp = @"timestamp",
    .uuid = @"uuid",
    .data = @"data",
    .occupancy = @"occupancy"
};


#pragma mark - Private interface methods

@interface PNPresenceEvent ()


#pragma mark Properties

@property (nonatomic, assign) PNPresenceEventType type;
@property (nonatomic, strong) PNClient *client;
@property (nonatomic, strong) PNDate *date;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, assign) NSUInteger occupancy;
@property (nonatomic, assign) PNChannel *channel;


@end


#pragma mark - Public interface methods

@implementation PNPresenceEvent


#pragma mark Class methods

+ (id)presenceEventForResponse:(id)presenceResponse {
    
    return [[[self class] alloc] initWithResponse:presenceResponse];
}

+ (BOOL)isPresenceEventObject:(NSDictionary *)event {

    BOOL isPresenceEventObject = ([event objectForKey:PNPresenceEventDataKeys.timestamp] != nil &&
                                  [event objectForKey:PNPresenceEventDataKeys.occupancy] != nil);
    if (!isPresenceEventObject) {

        isPresenceEventObject = ([event objectForKey:PNPresenceEventDataKeys.action] != nil &&
                                 [event objectForKey:PNPresenceEventDataKeys.uuid] != nil);
    }

    return isPresenceEventObject;
}


#pragma mark - Instance methods

- (id)initWithResponse:(id)presenceResponse {
    
    // Check whether initialization successful or not
    if((self = [super init])) {

        // Extracting event type from response
        self.type = PNPresenceEventJoin;
        NSString *type = [presenceResponse valueForKey:PNPresenceEventDataKeys.action];
        if ([type isEqualToString:@"leave"]) {

            self.type = PNPresenceEventLeave;
        }
        else if ([type isEqualToString:@"timeout"]) {

            self.type = PNPresenceEventTimeout;
        }
        else if ([type isEqualToString:@"state-change"]){

            self.type = PNPresenceEventStateChanged;
        }
        else if (type == nil){

            self.type = PNPresenceEventChanged;
        }

        // Extracting event date from response
        NSNumber *timestamp = [presenceResponse valueForKey:PNPresenceEventDataKeys.timestamp];
        self.date = [PNDate dateWithToken:timestamp];

        // Extracting channel occupancy from response
        self.occupancy = [[presenceResponse valueForKey:PNPresenceEventDataKeys.occupancy] unsignedIntegerValue];
        
        // Extracting client specific state
        self.client = [PNClient clientForIdentifier:[presenceResponse valueForKey:PNPresenceEventDataKeys.uuid]
                                            channel:nil
                                            andData:[presenceResponse valueForKey:PNPresenceEventDataKeys.data]];
        
        /**
         DEPRECATED. WILL BE COMPLETELY REMOVED IN PubNub 3.5.5
         */
        // Extracting user identifier from response
        _uuid = [presenceResponse valueForKey:PNPresenceEventDataKeys.uuid];
    }
    
    
    return self;
}


#pragma mark - Misc methods

- (void)setChannel:(PNChannel *)channel {

    _channel = channel;
    self.client.channel = channel;
}

- (NSString *)description {

    NSString *action = @"join";
    if (self.type == PNPresenceEventLeave) {

        action = @"leave";
    }
    else if (self.type == PNPresenceEventTimeout) {

        action = @"timeout";
    }
    else if (self.type == PNPresenceEventStateChanged) {

        action = @"state changed";
    }
    else if (self.type == PNPresenceEventChanged) {

        action = @"occupancy changed";
    }


    return [NSString stringWithFormat:@"%@\nEVENT: %@%@\nDATE: %@\nOCCUPANCY: %ld\nCHANNEL: %@",
                    NSStringFromClass([self class]), action, [NSString stringWithFormat:@"\nCLIENT: %@", self.client],
                    self.date, (unsigned long)self.occupancy, self.channel];
}

#pragma mark -


@end
