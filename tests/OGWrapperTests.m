/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGWrapperTests.h"

@implementation OGWrapperTests

- (void)testRetainAndReleaseAgainUntilGObjectVanishes {
  OTAssertNotNil(_myWrapper);
  g_object_unref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 1);
  OTAssertEqual(_myWrapper.retainCount, 1);

  [_myWrapper retain];
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 1);
  OTAssertEqual(_myWrapper.retainCount, 2);

  [_myWrapper release];
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 1);
  OTAssertEqual(_myWrapper.retainCount, 1);

  [_myWrapper release];
  OTAssertEqual(_gobject, NULL);
}

@end
