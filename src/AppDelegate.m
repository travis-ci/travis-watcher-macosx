//
//  AppDelegate.m
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import "TravisEventFetcher.h"
#import "BuildEvent.h"
#import "Preferences.h"
#import "Notification.h"
#import "NotificationDisplayer.h"
#import "TravisAPI.h"
#import "FilterPreferences.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BuildEventStream.h"

@interface AppDelegate () <NSUserNotificationCenterDelegate>
@property (strong) NSStatusItem *statusItem;
@property (strong) BuildEventStream *buildEventStream;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [[Preferences sharedPreferences] setupDefaults];

  [self setupGrowl];
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  [self setBuildEventStream:[BuildEventStream buildEventStream]];

  [[[[self buildEventStream] eventStream] filter:^(BuildEvent *event) {
    return [self shouldShowNotificationFor:event];
  }] subscribeNext:^(BuildEvent *event) {
    [[[TravisAPI standardAPI] fetchBuildWithID:[event buildID] forRepository:[event name]] subscribeNext:^(NSDictionary *build) {
      [event updateBuildInfo:build];
      Notification *notification = [Notification notificationWithEventData:event];
      [[NotificationDisplayer sharedNotificationDisplayer] deliverNotification:notification];
    } error:^(NSError *error) {
      NSLog(@"Couldn't get build info from JSON API. Error: %@.", error);
    }];
  }];

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
  [[self statusItem] setToolTip:@"Travis CI"];
  [[self statusItem] setHighlightMode:YES];
}

- (IBAction)showPreferences:(id)sender {
  [NSApp activateIgnoringOtherApps:YES];
  [[self preferencesPanel] makeKeyAndOrderFront:self];
}

- (BOOL)shouldShowNotificationFor:(BuildEvent *)eventData {
  FilterPreferences *filter;
  if ([[Preferences sharedPreferences] firehoseEnabled]) {
    filter = [FilterPreferences filterThatAcceptsAllRepositories];
  } else {
    filter = [FilterPreferences filtersWithMatches:[[Preferences sharedPreferences] repositories]];
  }

  return [filter matchesSlug:[eventData name]];
}

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
  if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked) {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification userInfo][@"URL"]]];
  }
}

@end
