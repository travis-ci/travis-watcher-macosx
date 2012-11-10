//
//  PreferencesController.h
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/18/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSObject <NSTableViewDataSource>
@property (assign) IBOutlet NSTableView *reposTableView;
@property (assign) IBOutlet NSPanel *preferencesPanel;

- (IBAction)addRepository:(id)sender;
- (IBAction)removeRepository:(id)sender;
- (IBAction)close:(id)sender;

@end
