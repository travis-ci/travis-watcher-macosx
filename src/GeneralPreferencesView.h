//
//  GeneralPreferencesView.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GeneralPreferencesView : NSView
@property (weak) IBOutlet NSTableView *reposTableView;
@property (weak) IBOutlet NSButtonCell *firehoseEnabledButtonCell;
@property (weak) IBOutlet NSButtonCell *firehoseDisabledButtonCell;
@property (weak) IBOutlet NSButton *addRepositoryButton;
@property (weak) IBOutlet NSButton *removeRepositoryButton;
@end
