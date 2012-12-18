//
//  PreferencesWindowController.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController
@property (weak) IBOutlet NSToolbar *toolbar;

- (IBAction)selectGeneralTab:(id)sender;
- (IBAction)selectAuthenticationTab:(id)sender;

@end
