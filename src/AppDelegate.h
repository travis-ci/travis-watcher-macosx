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
@property (assign) IBOutlet NSWindow *window;
@property (strong) PusherConnection *pusher;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSPanel *preferencesPanel;

- (IBAction)showPreferences:(id)sender;
@end
