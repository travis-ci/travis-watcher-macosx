//
//  PreferencesWindowController.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "PreferencesWindowController.h"

#import "GeneralPreferencesViewController.h"

@interface PreferencesWindowController ()
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
}

#pragma mark - API

- (void)setCurrentViewController:(NSViewController *)currentViewController {
  if (_currentViewController == currentViewController) return;

  _currentViewController = currentViewController;

  [[self window] setContentView:[[self currentViewController] view]];
}

@end
