/*
 * This file is part of ObjGTK
 *
 * Copyright (C) 2017 - Tyler Burton
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

/*
 * Modified by the ObjGTK Team, 2021. See the AUTHORS file for a
 * list of people on the ObjGTK Team.
 * See the ChangeLog files for a list of changes.
 */

/*
 * Objective-C imports
 */
#import "OGObject.h"
#import "OGObjectInitializationFailedException.h"

@implementation OGObject

+ (OGObject *)withGObject:(GObject *)obj
{
	OGObject *retVal = [[OGObject alloc] initWithGObject:obj];
	return [retVal autorelease];
}

- (instancetype)initWithGObject:(GObject *)obj
{
	self = [super init];

	@try {
		if (obj == NULL)
			@throw [OGObjectInitializationFailedException
			    exceptionWithClass:[self class]];

		[self setGObject:obj];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)setGObject:(GObject *)obj
{
	if (_gObject != NULL) {
		// Decrease the reference count on the previously stored GObject
		g_object_unref(_gObject);
	}

	_gObject = obj;

	if (_gObject != NULL) {
		// Increase the reference count on the new GObject
		g_object_ref(_gObject);
	}
}

- (GObject *)GOBJECT
{
	return _gObject;
}

- (void)dealloc
{
	if (_gObject != NULL) {
		// Decrease the reference count on the previously stored GObject
		g_object_unref(_gObject);
		_gObject = NULL;
	}
	[super dealloc];
}

@end
