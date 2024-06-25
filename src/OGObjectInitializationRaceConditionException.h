/*
 * SPDX-FileCopyrightText: 2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObjectInitializationFailedException.h"
#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OGObjectInitializationRaceConditionException: OGObjectInitializationFailedException

- (OFString *)description;

@end

OF_ASSUME_NONNULL_END
