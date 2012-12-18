//
//  AuthenticationPreferencesViewController.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "AuthenticationPreferencesViewController.h"

#import "AuthenticationPreferencesView.h"

#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "GitHubAuthentication.h"
#import "TravisAuthenticator.h"
#import "TravisAPI.h"
#import "TravisKeychain.h"
#import "Preferences.h"

@interface AuthenticationPreferencesViewController ()
@property (nonatomic, strong) AuthenticationPreferencesView *authenticationPreferencesView;
@property (nonatomic, strong) RACAsyncCommand *signInCommand;
@property (nonatomic, strong) RACAsyncCommand *signOutCommand;
@property (nonatomic, strong) RACAsyncCommand *enableSelfNotificationsCommand;
@end

@implementation AuthenticationPreferencesViewController

- (id)init {
  self = [super init];
  if (self == nil) return nil;

  _signInCommand = [RACAsyncCommand command];
  _signOutCommand = [RACAsyncCommand command];
  _enableSelfNotificationsCommand = [RACAsyncCommand command];

  return self;
}

- (void)loadView {
  NSNib *nib = [[NSNib alloc] initWithNibNamed:@"AuthenticationPreferencesView" bundle:nil];
  NSArray *topLevelObjects = nil;
  BOOL success = [nib instantiateNibWithOwner:self topLevelObjects:&topLevelObjects];
  if (!success) {
    [self setView:nil];
    return;
  }

  for (id topLevelObject in topLevelObjects) {
    if ([topLevelObject isKindOfClass:[AuthenticationPreferencesView class]]) {
      [self setView:topLevelObject];
    }
  }

  [self setAuthenticationPreferencesView:(AuthenticationPreferencesView *)[self view]];

  [self viewDidLoad];
}

- (void)setupForLoggedOutUser {
  [[[self authenticationPreferencesView] signInButton] setRac_command:[self signInCommand]];
  [[[self authenticationPreferencesView] signInButton] setTitle:@"Log In With GitHub"];
  [[[self authenticationPreferencesView] signInButton] setHidden:NO];
  [[[self authenticationPreferencesView] enableSelfNotificationsButton] setHidden:YES];
  RAC(self.authenticationPreferencesView.statusLabel.stringValue) = [[GitHubAuthentication sharedAuthenticator] authenticationStatus];

  [[[self signInCommand] deliverOn:[RACScheduler mainQueueScheduler]] subscribeNext:^(id _) {
    [self login];
  }];
}

- (void)login {
  [[[self authenticationPreferencesView] signInButton] setHidden:YES];
  [[[self authenticationPreferencesView] progressIndicator] startAnimation:self];

  @weakify(self);

  [[[GitHubAuthentication sharedAuthenticator] fetchAccessToken] subscribeNext:^(NSString *githubToken) {
    [[[TravisAuthenticator sharedAuthenticator] fetchAccessTokenWithGitHubToken:githubToken] subscribeNext:^(NSString *accessToken) {
      @strongify(self);
      [TravisKeychain setAccessToken:accessToken];
      [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
      [self setupForLoggedInUser];
    } error:^(NSError *error) {
      @strongify(self);
      [[[self authenticationPreferencesView] statusLabel] setStringValue:@"There was an error authenticating with Travis."];
      [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
      [self setupForLoggedOutUser];
      NSLog(@"Travis Error: %@", error);
    }];
  } error:^(NSError *error) {
    @strongify(self);
    [[[self authenticationPreferencesView] statusLabel] setStringValue:@"There was an error authenticating with GitHub."];
    [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
    [self setupForLoggedOutUser];
    NSLog(@"GitHub Error: %@", error);
  }];
}

- (void)setupForLoggedInUser {
  [[[self authenticationPreferencesView] signInButton] setRac_command:[self signOutCommand]];
  [[[self authenticationPreferencesView] signInButton] setTitle:@"Sign Out"];
  [[[self authenticationPreferencesView] signInButton] setHidden:NO];
  [[[self authenticationPreferencesView] enableSelfNotificationsButton] setHidden:NO];
  if ([[Preferences sharedPreferences] loggedInAs]) {
    NSString *newLabel = [NSString stringWithFormat:@"Logged in as %@", [[Preferences sharedPreferences] loggedInAs]];
    [[[self authenticationPreferencesView] statusLabel] setStringValue:newLabel];
  } else {
    [[[self authenticationPreferencesView] progressIndicator] startAnimation:self];
    [[[TravisAPI standardAPI] fetchUserInfo] subscribeNext:^(NSDictionary *userInfo) {
      [[Preferences sharedPreferences] setLoggedInAs:userInfo[@"login"]];
      NSString *newLabel = [NSString stringWithFormat:@"Logged in as %@", userInfo[@"login"]];
      [[[self authenticationPreferencesView] statusLabel] setStringValue:newLabel];
      [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
    }];
  }

  [[self signOutCommand] subscribeNext:^(id _) {
    [TravisKeychain deleteAccessToken];
    [[[self authenticationPreferencesView] statusLabel] setStringValue:@""];
    [self setupForLoggedOutUser];
  }];
}

- (void)viewDidLoad {
  if ([TravisKeychain accessToken]) {
    [self setupForLoggedInUser];
  } else {
    [self setupForLoggedOutUser];
  }

  [[[self authenticationPreferencesView] enableSelfNotificationsButton] setState:([[Preferences sharedPreferences] selfNotifications] ? NSOnState : NSOffState)];
  [[[self authenticationPreferencesView] enableSelfNotificationsButton] setRac_command:[self enableSelfNotificationsCommand]];
  [[self enableSelfNotificationsCommand] subscribeNext:^(NSButton *sender) {
    [[Preferences sharedPreferences] setSelfNotifications:[sender state] == NSOnState];
  }];
}


@end
