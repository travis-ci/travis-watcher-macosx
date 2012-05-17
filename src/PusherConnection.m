//
//  PusherConnection.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Growl/Growl.h>
#import <Pusher/PTPusherChannel.h>
#import <Pusher/PTPusherEvent.h>
#import "Constants.h"
#import "TravisEventData.h"

#import "PusherConnection.h"

@interface PusherConnection ()

@property (nonatomic, retain) PTPusher *pusher;
@property (nonatomic, retain) PTPusherChannel *channel;

- (void)handleStarted:(PTPusherEvent *)event;
- (void)handleFinished:(PTPusherEvent *)event;

@end

@implementation PusherConnection

@synthesize pusher = _pusher;
@synthesize channel = _channel;

- (id)init {
  self = [super init];
  if (self) {
    self.pusher = [PTPusher pusherWithKey:kPusherApiKey delegate:self encrypted:YES];
    self.pusher.reconnectAutomatically = YES;
    
    self.channel = [self.pusher subscribeToChannelNamed:kPusherChannelName];
    
    [self.channel bindToEventNamed:kPusherEventBuildStarted target:self action:@selector(handleStarted:)];
    [self.channel bindToEventNamed:kPusherEventBuildFinished target:self action:@selector(handleFinished:)];
  }
  
  return self;
}

- (void)handleStarted:(PTPusherEvent *)event {
  TravisEventData *eventData = [[[TravisEventData alloc] initWithEventData:event.data] retain];
  [GrowlApplicationBridge notifyWithTitle:eventData.name
                              description:@"Starting build!"
                         notificationName:@"Build Information"
                                 iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
  [eventData release];
}

- (void)handleFinished:(PTPusherEvent *)event {
  TravisEventData *eventData = [[[TravisEventData alloc] initWithEventData:event.data] retain];
  [GrowlApplicationBridge notifyWithTitle:eventData.name
                              description:[NSString stringWithFormat:@"Finished build with status: %@", eventData.status]
                         notificationName:@"Build Information"
                                 iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
  [eventData release];
}

@end
