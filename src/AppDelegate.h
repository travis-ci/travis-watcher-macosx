//
//  AppDelegate.h
//  Travis CI
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TravisEventFetcher;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (assign) IBOutlet NSMenu *statusMenu;

- (IBAction)showPreferences:(id)sender;

@end
