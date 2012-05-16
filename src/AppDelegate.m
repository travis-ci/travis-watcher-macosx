//
//  AppDelegate.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Pusher/PTPusherChannel.h>

#import "AppDelegate.h"
#include "Constants.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize pusher = _pusher;
@synthesize channel = _channel;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [GrowlApplicationBridge setGrowlDelegate:self];
  self.pusher = [PTPusher pusherWithKey:kPusherApiKey delegate:self encrypted:YES];
  
  self.pusher.reconnectAutomatically = YES;
  
  self.channel = [self.pusher subscribeToChannelNamed:kPusherChannelName];

  [self.channel bindToEventNamed:kPusherEventBuildStarted target:self action:@selector(buildStarted:)];
}

- (void)buildStarted:(PTPusherEvent *)event {
  [GrowlApplicationBridge notifyWithTitle:event.name description:[[event.data objectForKey:@"repository"] objectForKey:@"slug"] notificationName:@"Build Information" iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation] priority:0 isSticky:NO clickContext:nil];
}

@end
