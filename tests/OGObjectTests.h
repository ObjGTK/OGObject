/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "../src/OGObject.h"
#import <ObjFW/ObjFW.h>
#import <ObjFWTest/ObjFWTest.h>

OF_ASSUME_NONNULL_BEGIN

@interface OGObjectTests : OTTestCase {
  GObject *_gobject;
  OGObject *_myWrapper;
}

@property(nonatomic) GObject *gobject;
@property(nonatomic, retain) OGObject *myWrapper;

- (void)setUp;

@end

OF_ASSUME_NONNULL_END
