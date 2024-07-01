/*
 * SPDX-FileCopyrightText: 2024 Amrit Bhogal <ambhogal01@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import <ObjFW/ObjFW.h>

OF_ASSUME_NONNULL_BEGIN

@interface OGObjectSignalNotFoundException: OFException
{
    OFString *_signalName;
}

@property(readonly, atomic) OFString *signalName;

- (OFString *)description;

+ (instancetype)exceptionWithSignal:(OFString *)signalName;
- (instancetype)initWithSignal:(OFString *)signalName;

@end

OF_ASSUME_NONNULL_END
