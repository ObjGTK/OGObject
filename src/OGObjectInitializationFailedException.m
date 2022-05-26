/*
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@codingpastor.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
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