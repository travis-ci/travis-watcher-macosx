//
//  AppDelegate.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "PusherConnection.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) PusherConnection *pusher;
@property (nonatomic, assign) IBOutlet NSMenu *statusMenu;
@end
