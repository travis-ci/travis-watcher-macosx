//
//  PreferencesController.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Preferences;

@interface PreferencesController : NSObject <NSTableViewDataSource, NSWindowDelegate>

@property (nonatomic, strong) Preferences *preferences;

@property (assign) IBOutlet NSTableView *reposTableView;
@property (assign) IBOutlet NSPanel *preferencesPanel;
@property (weak) IBOutlet NSButtonCell *firehoseEnabledButtonCell;
@property (weak) IBOutlet NSButtonCell *firehoseDisabledButtonCell;
@property (weak) IBOutlet NSButtonCell *failureOnlyNotificationEnabledButtonCell;
@property (weak) IBOutlet NSButtonCell *failureOnlyNotificationDisabledButtonCell;

- (IBAction)addRepository:(id)sender;
- (IBAction)removeRepository:(id)sender;
- (IBAction)enableFirehose:(id)sender;
- (IBAction)disableFirehose:(id)sender;
- (IBAction)enableFailureOnlyNotification:(id)sender;
- (IBAction)disableFailureOnlyNotification:(id)sender;
- (IBAction)close:(id)sender;

@end
