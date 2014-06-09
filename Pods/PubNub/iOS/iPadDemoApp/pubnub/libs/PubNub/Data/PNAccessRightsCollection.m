//
//  PNAccessRightsCollection.m
//  pubnub
//
//  Created by Sergey Mamontov on 11/13/13.
//  Copyright (c) 2013 PubNub Inc. All rights reserved.
//


#import "PNAccessRightsInformation+Protected.h"
#import "PNAccessRightsCollection+Protected.h"
#import "PNAccessRightOptions+Protected.h"
#import "PNHelper.h"


#pragma mark Public interface implementation


@implementation PNAccessRightsCollection


#pragma mark - Class methods

+ (PNAccessRightsCollection *)accessRightsCollectionForApplication:(NSString *)applicationKey
                                              andAccessRightsLevel:(PNAccessRightsLevel)level {

    return [[self alloc] initWithApplication:applicationKey andAccessRightsLevel:level];
}


#pragma mark - Instance methods

- (id)initWithApplication:(NSString *)applicationKey andAccessRightsLevel:(PNAccessRightsLevel)level {

    // Check whether initialization was successful or not
    if ((self = [super init])) {

        self.applicationKey = applicationKey;
        self.channelsAccessRightsInformation = [NSMutableDictionary dictionary];
        self.clientsAccessRightsInformation = [NSMutableDictionary dictionary];
    }


    return self;
}

- (PNAccessRightsInformation *)accessRightsInformationForApplication {

    PNAccessRightsInformation *applicationInformation = self.applicationAccessRightsInformation;
    if (!self.applicationAccessRightsInformation) {

        applicationInformation = [PNAccessRightsInformation accessRightsInformationForLevel:PNApplicationAccessRightsLevel
                                           rights:PNUnknownAccessRights applicationKey:self.applicationKey
                                       forChannel:nil client:nil accessPeriod:0];
    }


    return applicationInformation;
}

- (NSArray *)accessRightsInformationForAllChannels {

    return [self.channelsAccessRightsInformation allValues];
}

- (PNAccessRightsInformation *)accessRightsInformationForChannel:(PNChannel *)channel {

    PNAccessRightsInformation *channelInformation = [self.channelsAccessRightsInformation valueForKey:channel.name];

    // Check whether there is no access rights information for specified channel or not.
    if (!channelInformation) {

        channelInformation = [PNAccessRightsInformation accessRightsInformationForLevel:PNChannelAccessRightsLevel
                                                               rights:PNUnknownAccessRights applicationKey:self.applicationKey
                                                           forChannel:channel client:nil accessPeriod:0];

        [self populateAccessRightsFrom:[self accessRightsInformationForApplication] to:channelInformation];
    }


    return channelInformation;
}

- (NSArray *)accessRightsForClientsOnChannel:(PNChannel *)channel {
    
    NSString *keyPortion = [NSString stringWithFormat:@"%@.", channel.name];
    NSSet *userInformationKeys = [self.clientsAccessRightsInformation keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        
        return [key rangeOfString:keyPortion].location != NSNotFound;
    }];
    
    
    return [[self.clientsAccessRightsInformation dictionaryWithValuesForKeys:[userInformationKeys allObjects]] allValues];
}

- (NSArray *)accessRightsInformationForAllClientAuthorizationKeys {

    return [self.clientsAccessRightsInformation allValues];
}

- (NSArray *)accessRightsInformationForClientAuthorizationKey:(NSString *)clientAuthorizationKey {

    // Filter out access rights information with specified client.
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"self.authorizationKey = %@", clientAuthorizationKey];


    return [[self.channelsAccessRightsInformation allValues] filteredArrayUsingPredicate:filterPredicate];
}

- (PNAccessRightsInformation *)accessRightsInformationClientAuthorizationKey:(NSString *)clientAuthorizationKey
                                                                   onChannel:(PNChannel *)channel {

    NSString *userInformationStoreKey = [NSString stringWithFormat:@"%@.%@", channel.name, clientAuthorizationKey];
    PNAccessRightsInformation *clientInformation = [self.clientsAccessRightsInformation valueForKey:userInformationStoreKey];

    // Check whether there is no access rights information for specified client or not.
    if (clientInformation == nil) {

        clientInformation = [PNAccessRightsInformation accessRightsInformationForLevel:PNUserAccessRightsLevel
                                                               rights:PNUnknownAccessRights applicationKey:self.applicationKey
                                                           forChannel:channel client:clientAuthorizationKey accessPeriod:0];

        [self populateAccessRightsFrom:[self accessRightsInformationForChannel:channel] to:clientInformation];
    }


    return clientInformation;
}

- (void)storeApplicationAccessRightsInformation:(PNAccessRightsInformation *)information {

    self.applicationAccessRightsInformation = information;
}

- (void)storeChannelAccessRightsInformation:(PNAccessRightsInformation *)information {

    [self populateAccessRightsFrom:[self accessRightsInformationForApplication] to:information];

    if (![self.channelsAccessRightsInformation objectForKey:information.channel.name]) {

        [self.channelsAccessRightsInformation setValue:information forKey:information.channel.name];
    }
}

- (void)storeClientAccessRightsInformation:(PNAccessRightsInformation *)information forChannel:(PNChannel *)channel {

    NSString *userInformationStoreKey = [NSString stringWithFormat:@"%@.%@", channel.name, information.authorizationKey];
    [self populateAccessRightsFrom:[self accessRightsInformationForChannel:channel] to:information];

    if (![self.clientsAccessRightsInformation objectForKey:userInformationStoreKey]) {

        [self.clientsAccessRightsInformation setValue:information forKey:userInformationStoreKey];
    }
}

- (void)correlateAccessRightsWithOptions:(PNAccessRightOptions *)options {

    [options.channels enumerateObjectsUsingBlock:^(PNChannel *channel, NSUInteger channelIdx,
                                                   BOOL *channelEnumeratorStop) {

        if (options.level != PNUserAccessRightsLevel) {

            [self storeChannelAccessRightsInformation:[PNAccessRightsInformation accessRightsInformationForLevel:PNChannelAccessRightsLevel
                                                                rights:PNNoAccessRights applicationKey:self.applicationKey
                                                            forChannel:channel client:nil accessPeriod:options.accessPeriodDuration]];
        }

        [options.clientsAuthorizationKeys enumerateObjectsUsingBlock:^(NSString *clientAuthorizationKey,
                                                                               NSUInteger clientAuthorizationKeyIdx,
                                                                               BOOL *clientAuthorizationKeyEnumeratorStop) {

                    [self storeClientAccessRightsInformation:[PNAccessRightsInformation accessRightsInformationForLevel:PNUserAccessRightsLevel
                                                                       rights:PNNoAccessRights applicationKey:self.applicationKey
                                                                   forChannel:channel client:clientAuthorizationKey
                                                                 accessPeriod:options.accessPeriodDuration]
                                                  forChannel:channel];
                }];
    }];
    
    self.level = options.level;
}


#pragma mark - Misc methods

- (void)populateAccessRightsFrom:(PNAccessRightsInformation *)sourceAccessRightsInformation
                              to:(PNAccessRightsInformation *)targetAccessRightsInformation {

    // Alter access rights if higher level available and has different access rights which can be used.
    if ([sourceAccessRightsInformation hasReadRight] || [sourceAccessRightsInformation hasWriteRight]) {

        unsigned long rights = targetAccessRightsInformation.rights;
        if ([sourceAccessRightsInformation hasAllRights]) {

            rights = (PNReadAccessRight | PNWriteAccessRight);
        }

        
        if ([sourceAccessRightsInformation hasReadRight] && ![PNBitwiseHelper is:rights containsBit:PNReadAccessRight]) {

            [PNBitwiseHelper addTo:&rights bit:PNReadAccessRight];
        }

        if ([sourceAccessRightsInformation hasWriteRight] && ![PNBitwiseHelper is:rights containsBit:PNWriteAccessRight]) {
            
            [PNBitwiseHelper addTo:&rights bit:PNWriteAccessRight];
        }

        targetAccessRightsInformation.rights = (PNAccessRights)rights;
    }
}

- (NSString *)description {

    NSString *indent = @"";
    NSMutableString *descriptionString = [NSMutableString stringWithString:@"\n"];

    if (self.applicationAccessRightsInformation != nil) {

        [descriptionString appendString:[self.applicationAccessRightsInformation description]];
    }

    if ([self.channelsAccessRightsInformation count]) {

        NSString *oldIndent = [NSString stringWithString:indent];
        [descriptionString appendFormat:@"\n%@Channels:\n", indent];

        indent = [indent stringByAppendingString:@"    "];
        [descriptionString appendString:indent];
        NSString *channelsJoinString = [NSString stringWithFormat:@"\n%@", indent];
        [descriptionString appendString:[[self.channelsAccessRightsInformation allValues]
               componentsJoinedByString:channelsJoinString]];

        indent = oldIndent;
    }

    if ([self.clientsAccessRightsInformation count]) {

        [descriptionString appendFormat:@"\n%@Clients:\n", indent];

        indent = [indent stringByAppendingString:@"    "];
        [descriptionString appendString:indent];
        NSString *clientsJoinString = [NSString stringWithFormat:@"\n%@", indent];
        [descriptionString appendString:[[self.clientsAccessRightsInformation allValues]
               componentsJoinedByString:clientsJoinString]];
    }


    return descriptionString;
}

#pragma mark -


@end
