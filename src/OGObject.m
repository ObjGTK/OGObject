/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObject.h"
#import "OGObjectInitializationFailedException.h"

static OFString const *OGObjectQuarkName = @"ogobject-objc-wrapper";
static GQuark OGObjectQuark = 0;

@implementation OGObject

+ (instancetype)wrapperFor:(void *)obj
{
	G_IS_OBJECT(obj);
	GQuark quark = [self quark];

	id wrapperObject = g_object_get_qdata(obj, quark);
	// OFLog(@"WrapperObject is %u", wrapperObject);
	if (wrapperObject != NULL && wrapperObject != nil &&
	    [wrapperObject isKindOfClass:[self class]]) {
		//	OFLog(@"Found a wrapper of type %@, returning.",
		//    [wrapperObject className]);
		return [wrapperObject autorelease];
	}

	// OFLog(@"Creating new instance of class %@.", [self className]);

	return [self withGObject:obj];
}

+ (GQuark)quark
{
	if (OGObjectQuark != 0)
		return OGObjectQuark;

	OGObjectQuark = g_quark_from_string([OGObjectQuarkName UTF8String]);
	return OGObjectQuark;
}

+ (instancetype)withGObject:(void *)obj
{
	G_IS_OBJECT(obj);

	id retVal = (id)[[self alloc] initWithGObject:obj];
	return [retVal autorelease];
}

- (instancetype)initWithGObject:(void *)obj
{
	G_IS_OBJECT(obj);

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

- (void)setGObject:(void *)obj
{
	G_IS_OBJECT(obj);

	if (_gObject != NULL) {
		g_object_set_qdata(_gObject, [OGObject quark], NULL);
		// Decrease the reference count on the previously stored GObject
		g_object_unref(_gObject);
	}

	_gObject = obj;

	if (_gObject != NULL) {
		g_object_set_qdata(_gObject, [OGObject quark], self);
		// Increase the reference count on the new GObject
		g_object_ref_sink(_gObject);
	}
}

- (GObject *)gObject
{
	return _gObject;
}

- (void)dealloc
{
	if (_gObject != NULL) {
		g_object_set_qdata(_gObject, [OGObject quark], NULL);
		// Decrease the reference count on the previously stored GObject
		g_object_unref(_gObject);
		_gObject = NULL;
	}
	[super dealloc];
}

@end