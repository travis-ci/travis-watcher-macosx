//
//  AppDelegate.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) NSStatusItem *statusItem;
@property (strong) NSImage *statusImage;
@property (strong) NSImage *statusHighlightImage;

@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize pusher = _pusher;
@synthesize statusMenu = _statusMenu;
@synthesize preferencesPanel = _preferencesPanel;
@synthesize statusItem = _statusItem;
@synthesize statusImage = _statusImage;
@synthesize statusHighlightImage = _statusHighlightImage;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *path = [[mainBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl"];
  if (NSAppKitVersionNumber >= 1038)
    path = [path stringByAppendingPathComponent:@"1.3"];
  else
    path = [path stringByAppendingPathComponent:@"1.2.3"];

  path = [path stringByAppendingPathComponent:@"Growl.framework"];
  NSBundle *growlFramework = [NSBundle bundleWithPath:path];
  [growlFramework load];

  self.pusher = [[PusherConnection alloc] init];
  
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
  NSBundle *bundle = [NSBundle mainBundle];
  
  self.statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"tray.png"]];
  self.statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForImageResource:@"tray-alt.png"]];
  
  self.statusItem.image = self.statusImage;
  self.statusItem.alternateImage = self.statusHighlightImage;
  
  self.statusItem.menu = self.statusMenu;
  self.statusItem.toolTip = @"Travis Toolbar";
  self.statusItem.highlightMode = YES;
}

- (IBAction)showPreferences:(id)sender {
  [NSApp activateIgnoringOtherApps:YES];
  [self.preferencesPanel makeKeyAndOrderFront:self];
}
@end
