//
//  AppDelegate.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize pusher = _pusher;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  self.pusher = [[PusherConnection alloc] init];
}

@end
