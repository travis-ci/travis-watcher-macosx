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

@interface AuthenticationPreferencesViewController ()
@property (nonatomic, strong) AuthenticationPreferencesView *authenticationPreferencesView;
@property (nonatomic, strong) RACAsyncCommand *signInCommand;
@property (nonatomic, strong) RACAsyncCommand *signOutCommand;
@end

@implementation AuthenticationPreferencesViewController

- (id)init {
  self = [super init];
  if (self == nil) return nil;

  _signInCommand = [RACAsyncCommand command];
  _signOutCommand = [RACAsyncCommand command];

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
  RAC(self.authenticationPreferencesView.statusLabel.stringValue) = [[GitHubAuthentication sharedAuthenticator] authenticationStatus];

  [[[self signInCommand] deliverOn:[RACScheduler mainQueueScheduler]] subscribeNext:^(id _) {
    [self login];
  }];
}

- (void)login {
  [[[self authenticationPreferencesView] signInButton] setHidden:YES];
  [[[self authenticationPreferencesView] progressIndicator] startAnimation:self];

  [[[[GitHubAuthentication sharedAuthenticator] fetchAccessToken]
   flattenMap:^(NSString *githubToken) {
     return [[TravisAuthenticator sharedAuthenticator] fetchAccessTokenWithGitHubToken:githubToken];
   }]
   subscribeNext:^(NSString *accessToken) {
     [TravisKeychain setAccessToken:accessToken];
     [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
     [self setupForLoggedInUser];
   }];
}

- (void)setupForLoggedInUser {
  [[[self authenticationPreferencesView] signInButton] setRac_command:[self signOutCommand]];
  [[[self authenticationPreferencesView] signInButton] setTitle:@"Sign Out"];
  [[[self authenticationPreferencesView] signInButton] setHidden:NO];
  [[[self authenticationPreferencesView] progressIndicator] startAnimation:self];
  [[[TravisAPI standardAPI] fetchUserInfo] subscribeNext:^(NSDictionary *userInfo) {
    NSString *newLabel = [NSString stringWithFormat:@"Logged in as %@", userInfo[@"login"]];
    [[[self authenticationPreferencesView] statusLabel] setStringValue:newLabel];
    [[[self authenticationPreferencesView] progressIndicator] stopAnimation:self];
  }];

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
}


@end
