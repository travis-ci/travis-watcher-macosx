//
//  AppDelegate.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import "TravisEventFetcher.h"
#import "TravisEvent.h"
#import "Preferences.h"
#import "Notification.h"
#import "NotificationDisplayer.h"
#import "TravisAPI.h"

@interface AppDelegate () <TravisEventFetcherDelegate, NSUserNotificationCenterDelegate>

@property (strong) TravisEventFetcher *eventFetcher;
@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [self setupGrowl];
  [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;

  self.eventFetcher = [[TravisEventFetcher alloc] init];
  self.eventFetcher.delegate = self;

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

- (BOOL)shouldShowNotificationFor:(TravisEvent *)eventData {
  if (Preferences.sharedPreferences.firehoseEnabled) return YES;

  NSArray *incomingComponents = [eventData.name componentsSeparatedByString:@"/"];
  NSString *incomingOwner = incomingComponents[0];
  NSString *incomingName = incomingComponents[1];
  NSArray *repositories = Preferences.sharedPreferences.repositories;
  for (NSString *repository in repositories) {
    NSArray *filterComponents = [repository componentsSeparatedByString:@"/"];
    NSString *filterOwner = filterComponents[0];
    NSString *filterName = filterComponents[1];

    if (![filterOwner isEqualToString:@"*"] && ![filterOwner isEqualToString:incomingOwner]) continue;
    else if (![filterName isEqualToString:@"*"] && ![filterName isEqualToString:incomingName]) continue;
    else return YES;
  }

  return NO;
}

#pragma mark - TravisEventFetcherDelegate

- (void)eventFetcher:(TravisEventFetcher *)eventFetcher gotEvent:(TravisEvent *)event {
  if ([self shouldShowNotificationFor:event]) {
    [[TravisAPI new] getBuildWithID:event.buildID forRepository:event.name success:^(NSDictionary *build) {
      [event updateBuildInfo:build];
      Notification *notification = [Notification notificationWithEventData:event];
      [NotificationDisplayer.sharedNotificationDisplayer deliverNotification:notification];
    } failure:^(NSError *error) {
      NSLog(@"Couldn't get build info from JSON API. Error: %@.", error);
    }];
  }
}

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
  if (notification.activationType == NSUserNotificationActivationTypeContentsClicked) {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:notification.userInfo[@"URL"]]];
  }
}

@end
