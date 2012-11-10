//
//  PreferencesController.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Preferences.h"

#import "PreferencesController.h"

@interface PreferencesController ()
@property (strong) NSArray *repos;

@end

@implementation PreferencesController

- (id)init {
  self = [super init];
  if (self) {
    self.repos = [[Preferences alloc] objectForKey:@"repositories"];
    if (!self.repos) self.repos = @[];
  }
  
  return self;
}

#pragma mark -
#pragma mark Actions

- (IBAction)addRepository:(id)sender {
  self.repos = [self.repos arrayByAddingObject:@"travis-ci/travis-ci"];
  [self.reposTableView reloadData];
}

- (IBAction)removeRepository:(id)sender {
  if (self.reposTableView.selectedRow != -1) {
    NSMutableArray *newArray = [self.repos mutableCopy];
    [newArray removeObjectAtIndex:self.reposTableView.selectedRow];
    self.repos = [newArray copy];
    [self.reposTableView reloadData];
  }
}

- (IBAction)saveSettings:(id)sender {
  [[Preferences alloc] setObject:self.repos forKey:@"repositories"];
  [self.preferencesPanel performClose:self];
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [self.repos count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return (self.repos)[row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSMutableArray *newArray = [self.repos mutableCopy];
  newArray[row] = object;
  self.repos = [newArray copy];
}

@end
