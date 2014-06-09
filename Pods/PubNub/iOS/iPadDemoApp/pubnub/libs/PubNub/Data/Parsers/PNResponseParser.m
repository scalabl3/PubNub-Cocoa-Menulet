/**

 @author Sergey Mamontov
 @version 3.4.0
 @copyright © 2009-13 PubNub Inc.

 */

#import "PNResponseParser.h"
#import "PNAccessRightsResponseParser+Protected.h"
#import "PNPushNotificationsEnabledChannelsParser.h"
#import "PNClientStateUpdateResponseParser.h"
#import "PNActionResponseParser+Protected.h"
#import "PNChannelHistoryParser+Protected.h"
#import "PNOperationStatusResponseParser.h"
#import "PNErrorResponseParser+Protected.h"
#import "PNChannelEventsResponseParser.h"
#import "PNClientStateResponseParser.h"
#import "PNServiceResponseCallbacks.h"
#import "PNTimeTokenResponseParser.h"
#import "PNWhereNowResponseParser.h"
#import "PNHereNowResponseParser.h"
#import "PNActionResponseParser.h"
#import "PNErrorResponseParser.h"
#import "PNResponse+Protected.h"


// ARC check
#if !__has_feature(objc_arc)
#error PubNub response parser must be built with ARC.
// You can turn on ARC for only PubNub files by adding '-fobjc-arc' to the build phase for each of its files.
#endif


#pragma mark Private interface methods

@interface PNResponseParser ()


#pragma mark - Class methods

/**
 Retrieve reference on parser class which is able to parse data from \b PNResponse instance.

 @param response
 \b PNResponse instance for which method should return reference on correct parser class.

 @return Class of the parser which is able to parse data from response.
 */
+ (Class)classForResponse:(PNResponse *)response;

/**
 Verify whether suggested class is able to process provided data payload or it doesn't recognize it's structure.

 @param response
 \b PNParser instance against which check should be performed.

 @return \c YES in case if suggested parser is able to handle provided data.
 */
+ (BOOL)isResponseConformToRequiredStructure:(PNResponse *)response;

#pragma mark -


@end


#pragma mark - Public interface methods

@implementation PNResponseParser


#pragma mark - Class methods

+ (PNResponseParser *)parserForResponse:(PNResponse *)response {
    
    if ([response.response isKindOfClass:[NSArray class]] && [response.callbackMethod isEqualToString:PNServiceResponseCallbacks.messageHistoryCallback] &&
        [PNChannelHistoryParser isErrorResponse:response]) {
        
        if ([PNChannelHistoryParser errorMessage:response]) {
            
            response = [PNResponse errorResponseWithMessage:[PNChannelHistoryParser errorMessage:response]];
        }
    }

    Class parserClass = [self classForResponse:response];

    // Looks like server provided response which doesn't conform to standards required for concrete packet processing.
    if (!parserClass) {

        parserClass = [PNErrorResponseParser class];
        response = nil;
    }


    return [[parserClass alloc] initWithResponse:response];
}

+ (Class)classForResponse:(PNResponse *)response {

    Class parserClass = nil;

    if ([response.response isKindOfClass:[NSArray class]]) {

        // Check whether result is result for "Time token" request or not.
        if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.timeTokenCallback]) {

            parserClass = [PNTimeTokenResponseParser class];
        }
        // Check whether result is result for "Push notification enabled channels" request or not.
        else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.pushNotificationEnabledChannelsCallback]) {

            parserClass = [PNPushNotificationsEnabledChannelsParser class];
        }
        // Check whether result is result for push notification state manipulation request or not.
        else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.channelPushNotificationsEnableCallback] ||
                 [response.callbackMethod isEqualToString:PNServiceResponseCallbacks.channelPushNotificationsDisableCallback] ||
                 [response.callbackMethod isEqualToString:PNServiceResponseCallbacks.pushNotificationRemoveCallback] ||
                 [response.callbackMethod isEqualToString:PNServiceResponseCallbacks.sendMessageCallback]) {

            parserClass = [PNOperationStatusResponseParser class];
        }
        // Check whether result is result for "Channel History" request or not.
        else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.messageHistoryCallback]) {

            parserClass = [PNChannelHistoryParser class];
        }
        // Check whether result is result for "Subscribe" request or not.
        else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.subscriptionCallback]) {

            parserClass = [PNChannelEventsResponseParser class];
        }
    }
    // Check whether response arrived as result of specific action execution.
    if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.leaveChannelCallback]) {

        parserClass = [PNActionResponseParser class];
    }
    // Check whether result is result for "State retrieval" request or not.
    else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.stateRetrieveCallback]) {

        parserClass = [PNClientStateResponseParser class];
    }
    // Check whether result is result for "State update" request or not.
    else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.stateUpdateCallback]) {

        parserClass = [PNClientStateUpdateResponseParser class];
    }
    // Check whether result is result for "Here now" request execution or not.
    else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.channelParticipantsCallback]) {
        
        if (![response isErrorResponse]) {
            
            parserClass = [PNHereNowResponseParser class];
        }
    }
    // Check whether result is result for "Where now" request execution or not.
    else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.participantChannelsCallback]) {

        parserClass = [PNWhereNowResponseParser class];
    }
    // Check whether response arrived as result of channel access rights change or not.
    else if ([response.callbackMethod isEqualToString:PNServiceResponseCallbacks.channelAccessRightsChangeCallback] ||
             [response.callbackMethod isEqualToString:PNServiceResponseCallbacks.channelAccessRightsAuditCallback]) {

        if (![response isErrorResponse]) {

            parserClass = [PNAccessRightsResponseParser class];
        }
    }

    if (parserClass == nil) {
        
        parserClass = [PNErrorResponseParser class];
    }
    else if (![parserClass isResponseConformToRequiredStructure:response]){

        parserClass = nil;
    }


    return parserClass;
}

+ (BOOL)isResponseConformToRequiredStructure:(PNResponse *)response {

    return YES;
}


#pragma mark - Instance methods

- (id)parsedData {

    NSAssert1(0, @"%s SHOULD BE RELOADED IN SUBCLASSES", __PRETTY_FUNCTION__);


    return nil;
}

#pragma mark -


@end
