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

@implementation PreferencesControllerTests

- (void)testEnableFirehoseSetting {
  Preferences *preferences = mock([Preferences class]);
  PreferencesController *controller = [PreferencesController new];
  controller.preferences = preferences;
  [controller enableFirehose:nil];

  [verify(preferences) setFirehoseEnabled:YES];
}

@end
