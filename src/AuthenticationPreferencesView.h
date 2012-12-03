//
//  AuthenticationPreferencesView.h
//  Travis CI
//
//  Created by Henrik Hodne on 12/3/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AuthenticationPreferencesView : NSView
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSButton *signInButton;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@end
