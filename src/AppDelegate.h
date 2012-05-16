//
//  AppDelegate.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Pusher/PTPusher.h>
#import <Pusher/PTPusherEvent.h>
#import <Growl/Growl.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, PTPusherDelegate, GrowlApplicationBridgeDelegate>
@property (assign) IBOutlet NSWindow *window;
@property (strong) PTPusher *pusher;

- (void)buildStarted:(PTPusherEvent *)event;
@end
