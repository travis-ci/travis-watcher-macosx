//
//  PreferencesControllerTests.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 11/11/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "Preferences.h"
#import "PreferencesController.h"

@interface PreferencesControllerTests : SenTestCase
@end

@implementation PreferencesControllerTests {
  Preferences *_preferences;
  PreferencesController *_preferencesController;
}

- (void)setUp {
  _preferences = mock([Preferences class]);
  _preferencesController = [PreferencesController new];
  _preferencesController.preferences = _preferences;
}

- (void)testEnableFirehoseSetting {
  [_preferencesController enableFirehose:nil];
  [verify(_preferences) setFirehoseEnabled:YES];
}

- (void)testDisableFirehoseSetting {
  [_preferencesController disableFirehose:nil];
  [verify(_preferences) setFirehoseEnabled:NO];
}

@end
