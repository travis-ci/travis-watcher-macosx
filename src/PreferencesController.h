//
//  PreferencesController.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject <NSTableViewDataSource, NSWindowDelegate>
@property (assign) IBOutlet NSTableView *reposTableView;
@property (assign) IBOutlet NSPanel *preferencesPanel;
@property (weak) IBOutlet NSButtonCell *firehoseEnabledButtonCell;
@property (weak) IBOutlet NSButtonCell *firehoseDisabledButtonCell;

- (IBAction)addRepository:(id)sender;
- (IBAction)removeRepository:(id)sender;
- (IBAction)enableFirehose:(id)sender;
- (IBAction)disableFirehose:(id)sender;
- (IBAction)close:(id)sender;

@end
