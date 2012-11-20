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
#import "RepositoryFilter.h"

@interface AppDelegate () <TravisEventFetcherDelegate, NSUserNotificationCenterDelegate>

@property (strong) TravisEventFetcher *eventFetcher;
@property (strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [[Preferences sharedPreferences] setupDefaults];

  [self setupGrowl];
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  [self setEventFetcher:[[TravisEventFetcher alloc] init]];
  [[self eventFetcher] setDelegate:self];

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
  [self setStatusItem:[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength]];

  [[self statusItem] setImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"tray.png"]]];
  [[self statusItem] setAlternateImage:[[NSImage alloc] initByReferencingFile:[[NSBundle mainBundle] pathForImageResource:@"tray-alt.png"]]];

  [[self statusItem] setMenu:[self statusMenu]];
  [[self statusItem] setToolTip:@"Travis Toolbar"];
  [[self statusItem] setHighlightMode:YES];
}

- (IBAction)showPreferences:(id)sender {
  [NSApp activateIgnoringOtherApps:YES];
  [[self preferencesPanel] makeKeyAndOrderFront:self];
}

- (BOOL)shouldShowNotificationFor:(TravisEvent *)eventData {
  if ([[Preferences sharedPreferences] failureOnlyNotificationEnabled]) {
    if (eventData.status != TravisEventStatusFailed) {
      return FALSE;
    }
  }

  RepositoryFilter *filter;
  if ([[Preferences sharedPreferences] firehoseEnabled]) {
    filter = [RepositoryFilter filterThatAcceptsAllRepositories];
  } else {
    filter = [RepositoryFilter filtersWithMatches:[[Preferences sharedPreferences] repositories]];
  }

  return [filter acceptsRepository:[eventData name]];
}

#pragma mark - TravisEventFetcherDelegate

- (void)eventFetcher:(TravisEventFetcher *)eventFetcher gotEvent:(TravisEvent *)event {
  if ([self shouldShowNotificationFor:event]) {
    [[TravisAPI new] getBuildWithID:[event buildID] forRepository:[event name] success:^(NSDictionary *build) {
      [event updateBuildInfo:build];
      Notification *notification = [Notification notificationWithEventData:event];
      [[NotificationDisplayer sharedNotificationDisplayer] deliverNotification:notification];
    } failure:^(NSError *error) {
      NSLog(@"Couldn't get build info from JSON API. Error: %@.", error);
    }];
  }
}

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
  if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked || [notification activationType] == NSUserNotificationActivationTypeActionButtonClicked) {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification userInfo][@"URL"]]];
  }
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
  // Show notifications when the Preferences panel is visible.
  return TRUE;
}

@end
