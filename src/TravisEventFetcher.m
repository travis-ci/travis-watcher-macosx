//
//  TravisEventFetcher.m
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "TravisEventFetcher.h"

#import <Pusher/PTPusher.h>
#import <Pusher/PTPusherChannel.h>
#import <Pusher/PTPusherEvent.h>
#import "Constants.h"
#import "TravisEvent.h"
#import "Preferences.h"
#import "Reachability.h"
#import "Notification.h"
#import "NotificationDisplayer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TravisEventFetcher () <PTPusherDelegate>

@property (strong) PTPusher *pusher;
@property (strong) PTPusherChannel *channel;
@property (strong) Reachability *reachability;
@property (strong) RACReplaySubject *eventSubject;

@end

@implementation TravisEventFetcher

+ (TravisEventFetcher *)eventFetcher {
  return [self new];
}

- (id)init {
  self = [super init];
  if (self) {
    _pusher = [PTPusher pusherWithKey:kPusherApiKey delegate:self encrypted:YES];
    _channel = [_pusher subscribeToChannelNamed:kPusherChannelName];
    [_channel bindToEventNamed:kPusherEventBuildStarted target:self action:@selector(handleEvent:)];
    [_channel bindToEventNamed:kPusherEventBuildFinished target:self action:@selector(handleEvent:)];
    _eventSubject = [RACReplaySubject subject];
  }
  
  return self;
}

- (RACSignal *)eventStream {
  return [[self eventSubject]
          map:^(PTPusherEvent *event) {
            return [[TravisEvent alloc] initWithEventData:[event data]];
          }];
}

#pragma mark - PTPusherDelegate

- (void)pusher:(PTPusher *)client connectionDidConnect:(PTPusherConnection *)connection {
  [client setReconnectAutomatically:YES];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
  [self pusher:pusher connection:connection failedWithError:error];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
  if ([self reachability] == nil) {
    [self setReachability:[Reachability reachabilityForInternetConnection]];
  }
  
  if ([[self reachability] currentReachabilityStatus] == NotReachable) {
    // there is no point in trying to reconnect at this point
    [[self pusher] setReconnectAutomatically:NO];
    
    // start observing the reachability status to see when we come back online
    [[NSNotificationCenter defaultCenter] 
      addObserver:self 
         selector:@selector(reachabilityChanged:) 
             name:kReachabilityChangedNotification 
           object:[self reachability]];
    
    [[self reachability] startNotifier];
  }
}

- (void)reachabilityChanged:(NSNotification *)note {
  if ([[self reachability] currentReachabilityStatus] != NotReachable) {
    // we seem to have some kind of network reachability, so try again
    [[self pusher] connect];
    
    // we can stop observing reachability changes now
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self reachability] stopNotifier];
  }
}

- (void)handleEvent:(PTPusherEvent *)event {
  [[self eventSubject] sendNext:event];
}

@end
