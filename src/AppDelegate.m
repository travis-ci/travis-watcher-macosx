//
//  AppDelegate.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import "PusherConnection.h"

@interface AppDelegate ()

@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [self setupGrowl];

  self.pusher = [[PusherConnection alloc] init];

  [self setupStatusBarItem];
}

- (void)setupGrowl {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *path = [[mainBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl"];
  if (NSAppKitVersionNumber >= 1038)
    path = [path stringByAppendingPathComponent:@"1.3"];
  else
    path = [path stringByAppendingPathComponent:@"1.2.3"];

  path = [path stringByAppendingPathComponent:@"Growl.framework"];
  NSBundle *growlFramework = [NSBundle bundleWithPath:path];
  [growlFramework load];
}

- (void)setupStatusBarItem {
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];

  self.statusItem.image = [[NSImage alloc] initByReferencingFile:[NSBundle.mainBundle pathForImageResource:@"tray.png"]];
  self.statusItem.alternateImage = [[NSImage alloc] initByReferencingFile:[NSBundle.mainBundle pathForImageResource:@"tray-alt.png"]];

  self.statusItem.menu = self.statusMenu;
  self.statusItem.toolTip = @"Travis Toolbar";
  self.statusItem.highlightMode = YES;
}

- (IBAction)showPreferences:(id)sender {
  [NSApp activateIgnoringOtherApps:YES];
  [self.preferencesPanel makeKeyAndOrderFront:self];
}
@end
