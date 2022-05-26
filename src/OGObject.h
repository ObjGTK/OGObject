/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@codingpastor.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import <ObjFW/ObjFW.h>
#include <glib-object.h>

/**
 * The base class for all CoreGTK wrapper classes
 */
@interface OGObject: OFObject
{
	/**
	 * The internal GtkObject pointer
	 */
	GObject *_gObject;
}

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
+ (OGObject *)withGObject:(GObject *)obj;

/**
 * Returns a new instance of OGObject with the internal GObject set to obj
 *
 * @param obj
 * 	The internal GObject to use
 *
 * @returns a new OGObject
 */
- (id)initWithGObject:(GObject *)obj;

/**
 * Sets the internal GObject
 *
 * @param obj
 * 	The GObject to set internally
 */
- (void)setGObject:(GObject *)obj;

/**
 * Gets the internal GObject
 *
 * @returns the internal GObject
 */
- (GObject *)GOBJECT;

@end
