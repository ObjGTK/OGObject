/*
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import <ObjFW/ObjFW.h>
#include <glib-object.h>

@interface OGErrorException: OFException
{
	GQuark _gDomain;
	int _errNo;
	OFString *_message;
}

@property (readonly, nonatomic) OFString *domain;
@property (assign, atomic) int errNo;

+ (instancetype)exceptionWithGError:(GError *)err;

+ (void)throwForError:(GError *)err;

+ (void)throwForError:(GError *)err unrefGObject:(void *)gobject;

- (instancetype)initWithGError:(GError *)err;

@end
