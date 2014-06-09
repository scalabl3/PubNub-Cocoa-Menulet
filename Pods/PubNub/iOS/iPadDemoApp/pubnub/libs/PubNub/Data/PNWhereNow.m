/**

 @author Sergey Mamontov
 @version 3.6.0
 @copyright © 2009-13 PubNub Inc.

 */

#import "PNWhereNow+Protected.h"


#pragma mark Public interface implementation

@implementation PNWhereNow


#pragma mark - Class methods

+ (PNWhereNow *)whereNowForClientIdentifier:(NSString *)clientIdentifier andChannels:(NSArray *)channels {

    return [[self alloc] initWithClientIdentifier:clientIdentifier andChannels:channels];
}


#pragma mark - Instance methods

- (id)initWithClientIdentifier:(NSString *)clientIdentifier andChannels:(NSArray *)channels {

    // Check whether initialization has been successful or not
    if ((self = [super init])) {

        self.identifier = clientIdentifier;
        self.channels = channels;
    }


    return self;
}

#pragma mark -


@end
