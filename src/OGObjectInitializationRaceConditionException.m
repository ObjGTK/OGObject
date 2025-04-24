/*
 * SPDX-FileCopyrightText: 2024-2025 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObjectInitializationRaceConditionException.h"

@implementation OGObjectInitializationRaceConditionException

- (OFString *)description
{
	if (_inClass != nil)
		return [OFString stringWithFormat:@"While coupling a GObject instance (or a child "
		                                  @"instance) to an instance of class %@ "
		                                  @"mismatching values were detected. It may be "
		                                  @"assumed that a race condition occured.",
		                 _inClass];
	else
		return @"While coupling a GObject instance (or a child "
		       @"instance) to a (child)instance of class OGObject "
		       @"mismatching values were detected. It may be "
		       @"assumed that a race condition occured.";
}

@end
