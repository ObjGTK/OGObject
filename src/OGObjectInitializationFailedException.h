/*
 * SPDX-FileCopyrightText: 2021-2025 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OGObjectInitializationFailedException: OFInitializationFailedException

- (OFString *)description;

@end

OF_ASSUME_NONNULL_END