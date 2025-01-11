/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-FileCopyrightText: 2024 Amrit Bhogal <ambhogal01@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
#import <ObjFW/ObjFW.h>
#include <glib-object.h>

#import "OGErrorException.h"
#import "OGObjectGObjectToWrapCreationFailedException.h"

static OFString const *OGObjectQuarkName;
static GQuark OGObjectQuark;

id OGWrapperClassAndObjectForGObject(void *obj);

/**
 * The base class for all wrapper classes
 */
@interface OGObject: OFObject
{
	/**
	 * The internal GObject pointer
	 */
	GObject *_gObject;
}

+ (void)load;

+ (GQuark)wrapperQuark;

/**
 * Returns a new instance of OGObject with the internal GObject set to obj
 *
 * Note: the returned object is autoreleased
 *
 * @param obj
 * 	The internal GObject to use
 *
 * @returns a new OGObject
 */
+ (instancetype)withGObject:(void *)obj;

/**
 * Returns a new instance of OGObject with the internal GObject set to obj
 *
 * @param obj
 * 	The internal GObject to use
 *
 * @returns a new OGObject
 */
- (instancetype)initWithGObject:(void *)obj;

/**
 * Sets the internal GObject
 *
 * @param obj
 * 	The GObject to set internally
 */
- (void)setGObject:(void *)obj;

/**
 * Gets the internal GObject
 *
 * @returns the internal GObject
 */
- (GObject *)gObject;

/**
 * @brief      Connects a GObject signal named to a ObjC selector specified.
 *
 * @param      signal  Name of signal
 * @param      target  ObjC target target
 * @param      sel     ObjC selector
 * @return     The GObject handler ID (always greater than 0)
 */
- (gulong)connectSignal:(OFString *)signal target:(id)target selector:(SEL)sel;
- (gulong)connectSignal:(OFString *)signal target:(id)target selector:(SEL)sel after:(bool)connectAfter;

@end
