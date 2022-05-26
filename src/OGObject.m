/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@codingpastor.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
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
