/*
 * SPDX-FileCopyrightText: 2024-2025 Amrit Bhogal <ambhogal01@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#include "OGObjectSignalNotFoundException.h"

@implementation OGObjectSignalNotFoundException

@synthesize signalName = _signalName;

+ (instancetype)exceptionWithSignal: (OFString *)signalName
{
    return [[[self alloc] initWithSignal: signalName] autorelease];
}

- (instancetype)initWithSignal: (OFString *)signalName
{
    self = [super init];

    _signalName = [signalName copy];

    return self;
}

- (OFString *)description
{
    return [OFString stringWithFormat: @"Signal %@ not found", _signalName];
}

@end
