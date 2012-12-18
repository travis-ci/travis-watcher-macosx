//
//  PreferencesWindowController.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "PreferencesWindowController.h"

#import "GeneralPreferencesViewController.h"
#import "AuthenticationPreferencesViewController.h"

@interface PreferencesWindowController () <NSToolbarDelegate>
@property (nonatomic, strong) NSViewController *currentViewController;
@end

@implementation PreferencesWindowController

- (id)init {
  self = [super initWithWindowNibName:NSStringFromClass([self class]) owner:self];
  if (self == nil) return nil;

  return self;
}

#pragma mark - NSWindowController

- (void)windowDidLoad {
  [super windowDidLoad];

  GeneralPreferencesViewController *generalPreferencesViewController = [[GeneralPreferencesViewController alloc] init];
  [self setCurrentViewController:generalPreferencesViewController];
  [[self toolbar] setSelectedItemIdentifier:@"general"];
}

#pragma mark - API

- (void)setCurrentViewController:(NSViewController *)currentViewController {
  if (_currentViewController == currentViewController) return;

  _currentViewController = currentViewController;

  [[self window] setContentView:[[self currentViewController] view]];
}

- (IBAction)selectGeneralTab:(id)sender {
  GeneralPreferencesViewController *generalPreferencesViewController = [[GeneralPreferencesViewController alloc] init];
  [self setCurrentViewController:generalPreferencesViewController];
}

- (IBAction)selectAuthenticationTab:(id)sender {
  AuthenticationPreferencesViewController *authenticationPreferencesViewController = [[AuthenticationPreferencesViewController alloc] init];
  [self setCurrentViewController:authenticationPreferencesViewController];
}

#pragma mark - NSToolbarDelegate

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
  return @[ @"general", @"authentication" ];
}

@end
