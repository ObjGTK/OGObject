/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGGObjectTests.h"

@implementation OGGObjectTests

- (void)testObject {
  OTAssertNotNil(_myWrapper);

  OTAssertEqual(((GObject *)(_gobject))->ref_count, 2);
  OTAssertEqual(_myWrapper.retainCount, 2);
}

@end
