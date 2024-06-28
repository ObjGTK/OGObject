/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObjectTests.h"

@implementation OGObjectTests
@synthesize gobject = _gobject;
@synthesize myWrapper = _myWrapper;

- (void)dealloc {
  [_myWrapper release];

  [super dealloc];
}

- (void)setUp {
  [super setUp];

  _gobject = g_object_new(G_TYPE_OBJECT, NULL);
  g_object_add_weak_pointer(G_OBJECT(_gobject), (gpointer *)&_gobject);

  _myWrapper = [[OGObject alloc] init];
  [_myWrapper setGObject:_gobject];
}
@end
