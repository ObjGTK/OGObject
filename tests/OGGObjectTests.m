/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGGObjectTests.h"

@implementation OGGObjectTests

- (void)testRefAndUnrefAgainUntilGObjectVanishes {
  OTAssertNotNil(_myWrapper);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 2);
  OTAssertEqual(_myWrapper.retainCount, 2);

  g_object_unref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 1);
  OTAssertEqual(_myWrapper.retainCount, 1);

  g_object_ref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 2);
  OTAssertEqual(_myWrapper.retainCount, 2);

  g_object_ref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 3);
  OTAssertEqual(_myWrapper.retainCount, 2);

  g_object_unref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 2);
  OTAssertEqual(_myWrapper.retainCount, 2);

  g_object_unref(_gobject);
  OTAssertEqual(((GObject *)(_gobject))->ref_count, 1);
  OTAssertEqual(_myWrapper.retainCount, 1);

  g_object_unref(_gobject);
  OTAssertEqual(_gobject, NULL);
}

@end
