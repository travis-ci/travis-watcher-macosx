//
//  BuildEventStream.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/1/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "BuildEventStream.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Pusher/PTPusher.h>
#import <Pusher/PTPusherChannel.h>
#import <Pusher/PTPusherEvent.h>
#import "Reachability.h"
#import "TravisEvent.h"

static NSString * const BuildEventStreamPusherAPIKey = @"23ed642e81512118260e";
static NSString * const BuildEventStreamPusherChannelName = @"common";
static NSString * const BuildEventStreamPusherBuildStartedEvent = @"build:started";
static NSString * const BuildEventStreamPusherBuildFinishedEvent = @"build:finished";

@interface BuildEventStream () <PTPusherDelegate>
@property (nonatomic, strong, readonly) PTPusher *pusher;
@property (nonatomic, strong, readonly) PTPusherChannel *channel;
@property (nonatomic, strong, readonly) Reachability *reachability;
@property (nonatomic, strong, readonly) RACSubject *eventSubject;
@end

@implementation BuildEventStream

+ (BuildEventStream *)buildEventStream {
  return [[self alloc] init];
}

- (id)init {
  self = [super init];
  if (self == nil) return nil;

  _eventSubject = [RACSubject subject];
  _reachability = [Reachability reachabilityForInternetConnection];
  _pusher = [PTPusher pusherWithKey:BuildEventStreamPusherAPIKey delegate:self encrypted:YES];
  _channel = [_pusher subscribeToChannelNamed:BuildEventStreamPusherChannelName];
  [_channel bindToEventNamed:BuildEventStreamPusherBuildStartedEvent target:self action:@selector(handleEvent:)];
  [_channel bindToEventNamed:BuildEventStreamPusherBuildFinishedEvent target:self action:@selector(handleEvent:)];

  return self;
}

- (RACSignal *)eventStream {
  return [[self eventSubject] map:^(PTPusherEvent *pusherEvent) {
    return [[TravisEvent alloc] initWithEventData:[pusherEvent data]];
  }];
}

- (void)handleEvent:(PTPusherEvent *)event {
  [[self eventSubject] sendNext:event];
}

#pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)note {
  if ([[self reachability] currentReachabilityStatus] != NotReachable) {
    // we seem to have some kind of network reachability, so try again
    [[self pusher] connect];

    // we can stop observing reachability changes now
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[self reachability] stopNotifier];
  }
}

#pragma mark - PTPusherDelegate

- (void)pusher:(PTPusher *)client connectionDidConnect:(PTPusherConnection *)connection {
  [client setReconnectAutomatically:YES];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error {
  [self pusher:pusher connection:connection failedWithError:error];
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
  if ([[self reachability] currentReachabilityStatus] == NotReachable) {
    // there is no point in trying to reconnect at this point
    [pusher setReconnectAutomatically:NO];

    // start observing the reachability status to see when we come back online
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reachabilityChanged:)
     name:kReachabilityChangedNotification
     object:[self reachability]];

    [[self reachability] startNotifier];
  }
}

@end
