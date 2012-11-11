//
//  PreferencesController.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "Preferences.h"

#import "PreferencesController.h"

@implementation PreferencesController

- (Preferences *)preferences {
  if (_preferences == nil) {
    _preferences = [Preferences sharedPreferences];
  }

  return _preferences;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
  NSTextField *textField = (NSTextField *)[alert accessoryView];

  [[self preferences] addRepository:[textField stringValue]];
  [[self reposTableView] reloadData];
}

#pragma mark - Actions

- (IBAction)addRepository:(NSButton *)sender {
  NSAlert *alert = [NSAlert alertWithMessageText:@"Add repository" defaultButton:@"Add" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Enter the name of the repository you want to add (for example, \"travis-ci/travis-ci\" or \"travis-ci/*\")"];
  NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 23)];
  [alert setAccessoryView:textField];
  [alert beginSheetModalForWindow:[sender window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)removeRepository:(id)sender {
  if ([[self reposTableView] selectedRow] != -1) {
    NSString *repository = [self tableView:[self reposTableView] objectValueForTableColumn:nil row:[[self reposTableView] selectedRow]];
    [[self preferences] removeRepository:repository];
    [[self reposTableView] reloadData];
  }
}

- (IBAction)close:(id)sender {
  [[self preferencesPanel] performClose:self];
}

- (IBAction)enableFirehose:(id)sender {
  [[self preferences] setFirehoseEnabled:YES];
}

- (IBAction)disableFirehose:(id)sender {
  [[self preferences] setFirehoseEnabled:NO];
}

#pragma mark - NSWindowDelegate

- (void)windowDidBecomeKey:(NSNotification *)notification {
  if ([[self preferences] firehoseEnabled]) {
    [[self firehoseEnabledButtonCell] setObjectValue:@(YES)];
    [[self firehoseDisabledButtonCell] setObjectValue:@(NO)];
  } else {
    [[self firehoseEnabledButtonCell] setObjectValue:@(NO)];
    [[self firehoseDisabledButtonCell] setObjectValue:@(YES)];
  }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [[[self preferences] repositories] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[self preferences] repositories][row];
}

@end
