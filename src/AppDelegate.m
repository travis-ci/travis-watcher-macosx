//
//  AppDelegate.m
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AppDelegate.h"

#import "BuildEvent.h"
#import "Preferences.h"
#import "Notification.h"
#import "NotificationDisplayer.h"
#import "TravisAPI.h"
#import "FilterPreferences.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "BuildEventStream.h"
#import "EventFilter.h"
#import "EventConverter.h"

@interface AppDelegate () <NSUserNotificationCenterDelegate>
@property (strong) NSStatusItem *statusItem;
@property (strong) BuildEventStream *buildEventStream;
@property (strong) EventFilter *eventFilter;
@property (strong) EventConverter *eventConverter;
@property (strong) RACSignal *updatedBuilds;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [[Preferences sharedPreferences] setupDefaults];

  [self setupGrowl];
  [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

  [self setBuildEventStream:[BuildEventStream buildEventStream]];
  [self setEventFilter:[EventFilter eventFilterWithInputStream:[[self buildEventStream] eventStream] filterPreferences:[FilterPreferences filterWithPreferences:[Preferences sharedPreferences]]]];

  [self setUpdatedBuilds:[[[self eventFilter] outputStream] flattenMap:^(BuildEvent *event) {
    return [[[TravisAPI standardAPI] fetchBuildWithID:[event buildID] forRepository:[event name]] map:^(NSDictionary *build) {
      [event updateBuildInfo:build];
      return event;
    }];
  }]];

  [self setEventConverter:[EventConverter eventConverterWithInputStream:[self updatedBuilds]]];
  [[[self eventConverter] outputStream] subscribeNext:^(Notification *notification) {
    [[NotificationDisplayer sharedNotificationDisplayer] deliverNotification:notification];
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

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
  if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked) {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[notification userInfo][@"URL"]]];
  }
}

@end
