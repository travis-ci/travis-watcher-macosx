//
//  AppDelegate.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PusherConnection;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) PusherConnection *pusher;

@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSPanel *preferencesPanel;

- (IBAction)showPreferences:(id)sender;
@end
