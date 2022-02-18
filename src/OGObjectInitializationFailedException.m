/*
 * Copyright 2021 Johannes Brakensiek <letterus at codingpastor.de>
 *
 * This software is licensed under the GNU General Public License
 * (version 2.0 or later). See the LICENSE file in this distribution.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#import "OGObjectInitializationFailedException.h"

@implementation OGObjectInitializationFailedException

- (OFString *)description
{
	if (_inClass != nil)
		return [OFString
		    stringWithFormat:
		        @"Initialization of GObject instance (or a child "
		        @"instance) to be wrapped failed for or in class %@! "
		        @" Received NULL for OGObject initalization.",
		    _inClass];
	else
		return @"Initialization of GObject instance (or a child "
		       @"instance) to "
		       @"be wrapped failed. Received NULL for OGObject "
		       @"initalization.";
}

@end