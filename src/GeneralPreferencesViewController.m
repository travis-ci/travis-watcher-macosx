//
//  GeneralPreferencesViewController.m
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import "GeneralPreferencesViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>

#import "GeneralPreferencesView.h"
#import "Preferences.h"

@interface GeneralPreferencesViewController () <NSTableViewDataSource>
@property (nonatomic, strong) GeneralPreferencesView *generalPreferencesView;
@property (nonatomic, strong) RACAsyncCommand *addRepositoryCommand;
@property (nonatomic, strong) RACAsyncCommand *removeRepositoryCommand;
@property (nonatomic, strong) RACSubject *firehoseEnabledSignal;
@property (nonatomic, strong) Preferences *preferences;
@end

@implementation GeneralPreferencesViewController

- (id)init {
  self = [super init];
  if (self == nil) return nil;

  _preferences = [Preferences sharedPreferences];

  return self;
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
  if (returnCode == NSAlertDefaultReturn) {
    NSTextField *textField = (NSTextField *)[alert accessoryView];

    [[self preferences] addRepository:[textField stringValue]];
    [[[self generalPreferencesView] reposTableView] reloadData];
  }
}

- (void)setupCommands {
  [self setAddRepositoryCommand:[RACAsyncCommand command]];
  [[[self generalPreferencesView] addRepositoryButton] setRac_command:[self addRepositoryCommand]];

  [self setRemoveRepositoryCommand:[RACAsyncCommand command]];
  [[[self generalPreferencesView] removeRepositoryButton] setRac_command:[self removeRepositoryCommand]];

  [self setFirehoseEnabledSignal:[RACSubject subject]];
  [[[self generalPreferencesView] firehoseEnabledButtonCell] setTarget:self];
  [[[self generalPreferencesView] firehoseEnabledButtonCell] setAction:@selector(enabledFirehose)];
  [[[self generalPreferencesView] firehoseDisabledButtonCell] setTarget:self];
  [[[self generalPreferencesView] firehoseDisabledButtonCell] setAction:@selector(disabledFirehose)];

  @weakify(self);

  [[self addRepositoryCommand] subscribeNext:^(id _) {
    @strongify(self);
    NSAlert *alert = [NSAlert alertWithMessageText:@"Add repository" defaultButton:@"Add" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Enter the name of the repository you want to add (for example, \"travis-ci/travis-ci\" or \"travis-ci/*\")"];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 23)];
    [alert setAccessoryView:textField];
    [alert beginSheetModalForWindow:[[self view] window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
  }];

  [[self removeRepositoryCommand] subscribeNext:^(id _) {
    @strongify(self);
    if ([[[self generalPreferencesView] reposTableView] selectedRow] != -1) {
      NSString *repository = [self tableView:[[self generalPreferencesView] reposTableView] objectValueForTableColumn:nil row:[[[self generalPreferencesView] reposTableView] selectedRow]];
      [[self preferences] removeRepository:repository];
      [[[self generalPreferencesView] reposTableView] reloadData];
    }
  }];

  [[self firehoseEnabledSignal] subscribeNext:^(NSNumber *enabled) {
    @strongify(self);
    NSLog(@"Changed firehose setting to %@", enabled);
    [[self preferences] setFirehoseEnabled:[enabled boolValue]];
  }];
}

- (void)loadView {
  NSNib *nib = [[NSNib alloc] initWithNibNamed:@"GeneralPreferencesView" bundle:nil];
  NSArray *topLevelObjects = nil;
  BOOL success = [nib instantiateNibWithOwner:self topLevelObjects:&topLevelObjects];
  if (!success) {
    [self setView:nil];
    return;
  }

  for (id topLevelObject in topLevelObjects) {
    if ([topLevelObject isKindOfClass:[GeneralPreferencesView class]]) {
      [self setView:topLevelObject];
    }
  }

  [self setGeneralPreferencesView:(GeneralPreferencesView *)[self view]];

  [self viewDidLoad];
}

- (void)viewDidLoad {
  [[[self generalPreferencesView] reposTableView] setDataSource:self];
  [self setupCommands];

  if ([[self preferences] firehoseEnabled]) {
    [[[self generalPreferencesView] firehoseEnabledButtonCell] setIntegerValue:NSOnState];
    [[[self generalPreferencesView] firehoseDisabledButtonCell] setIntegerValue:NSOffState];
  } else {
    [[[self generalPreferencesView] firehoseEnabledButtonCell] setIntegerValue:NSOffState];
    [[[self generalPreferencesView] firehoseDisabledButtonCell] setIntegerValue:NSOnState];
  }
}

- (void)enabledFirehose {
  [[self firehoseEnabledSignal] sendNext:@(YES)];
}

- (void)disabledFirehose {
  [[self firehoseEnabledSignal] sendNext:@(NO)];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [[[self preferences] repositories] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [[self preferences] repositories][row];
}

@end
