//
//  PusherConnection.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Pusher/PTPusher.h>
#import <Pusher/PTPusherChannel.h>
#import <Pusher/PTPusherEvent.h>
#import "Constants.h"
#import "TravisEventData.h"
#import "Preferences.h"
#import "Reachability.h"
#import "Notification.h"
#import "NotificationManager.h"

#import "PusherConnection.h"

@interface PusherConnection () <PTPusherDelegate>

@property (strong) PTPusher *pusher;
@property (strong) PTPusherChannel *channel;
@property (strong) Reachability *reachability;

@end

@implementation PusherConnection

- (id)init {
  self = [super init];
  if (self) {
    self.pusher = [PTPusher pusherWithKey:kPusherApiKey delegate:self encrypted:YES];
    
    self.channel = [self.pusher subscribeToChannelNamed:kPusherChannelName];
    
    [self.channel bindToEventNamed:kPusherEventBuildStarted target:self action:@selector(handleEvent:)];
  }
  
  return self;
}

- (void)pusher:(PTPusher *)client connectionDidConnect:(PTPusherConnection *)connection {
  self.pusher.reconnectAutomatically = YES;
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
  [self pusher:pusher connection:connection failedWithError:error];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
  if (self.reachability == nil) {
    self.reachability = [Reachability reachabilityForInternetConnection];
  }
  
  if ([self.reachability currentReachabilityStatus] == NotReachable) {
    // there is no point in trying to reconnect at this point
    self.pusher.reconnectAutomatically = NO;
    
    // start observing the reachability status to see when we come back online
    [[NSNotificationCenter defaultCenter] 
      addObserver:self 
         selector:@selector(reachabilityChanged:) 
             name:kReachabilityChangedNotification 
           object:self.reachability];
    
    [self.reachability startNotifier];
  }
}

- (void)reachabilityChanged:(NSNotification *)note {
  if ([self.reachability currentReachabilityStatus] != NotReachable) {
    // we seem to have some kind of network reachability, so try again
    [self.pusher connect];
    
    // we can stop observing reachability changes now
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.reachability stopNotifier];
  }
}

- (void)handleEvent:(PTPusherEvent *)event {
  TravisEventData *eventData = [[TravisEventData alloc] initWithEventData:event.data];
  if ([self shouldShowNotificationFor:eventData]) {
    Notification *notification = [Notification notificationWithEventData:eventData];
    [NotificationManager.sharedNotificationManager deliverNotification:notification];
  }
}

- (BOOL)shouldShowNotificationFor:(TravisEventData *)eventData {
  NSArray *repositories = Preferences.sharedPreferences.repositories;
  return Preferences.sharedPreferences.firehoseEnabled || [repositories containsObject:eventData.name];
}

@end
