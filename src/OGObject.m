/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObject.h"
#import "OGObjectInitializationFailedException.h"

static OFString const *OGObjectQuarkName = @"ogobject-objc-wrapper";
static GQuark OGObjectQuark = 0;

// Global mutex
static OFPlainMutex globalMutex;

static void OGMutexFree(void)
{
	int error = OFPlainMutexFree(&globalMutex);

	if (error != 0) {
		OFEnsure(error == EBUSY);

		@throw [OFStillLockedException exception];
	};
}

OF_CONSTRUCTOR()
{
	OFEnsure(OFPlainMutexNew(&globalMutex) == 0);
	atexit(OGMutexFree);
}

static void OGMutexLock()
{
	int error = OFPlainMutexLock(&globalMutex);

	if (error != 0)
		@throw [OFLockFailedException exception];
}

static void OGMutexUnlock()
{
	int error = OFPlainMutexUnlock(&globalMutex);

	if (error != 0)
		@throw [OFUnlockFailedException exception];
}

static void ogo_ref_toggle_notify(gpointer data, GObject *object, gboolean is_last_ref)
{
	g_assert(data != NULL);
	g_assert(object != NULL);
	id wrapperObject = (id)data;

	OGMutexLock();
	@try {
		if (!is_last_ref && wrapperObject != nil && object != NULL)
			[wrapperObject retain];
		else if (is_last_ref && wrapperObject != nil && object != NULL)
			[wrapperObject release];
	} @finally {
		OGMutexUnlock();
	}
}

@interface OGObject ()
+ (GQuark)wrapperQuark;
@end

@implementation OGObject

+ (instancetype)wrapperFor:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));
	GQuark quark = [self wrapperQuark];

	OGMutexLock();
	@try {
		id wrapperObject = g_object_get_qdata(obj, quark);
		// OFLog(@"WrapperObject is %u", wrapperObject);
		if (wrapperObject != NULL && wrapperObject != nil &&
		    [wrapperObject isKindOfClass:[self class]]) {
			//	OFLog(@"Found a wrapper of type %@, returning.",
			//    [wrapperObject className]);
			return wrapperObject;
		}

		// OFLog(@"Creating new instance of class %@.", [self className]);
		return [self withGObject:obj];
	} @finally {
		OGMutexUnlock();
	}
}

+ (GQuark)wrapperQuark
{
	if (OGObjectQuark != 0)
		return OGObjectQuark;

	OGMutexLock();
	@try {
		OGObjectQuark = g_quark_from_string([OGObjectQuarkName UTF8String]);

		return OGObjectQuark;

	} @finally {
		OGMutexUnlock();
	}
}

+ (instancetype)withGObject:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));

	id retVal = (id)[[self alloc] initWithGObject:obj];
	return [retVal autorelease];
}

- (instancetype)initWithGObject:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));

	self = [super init];

	@try {
		if (obj == NULL)
			@throw
			    [OGObjectInitializationFailedException exceptionWithClass:[self class]];

		[self setGObject:obj];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)setGObject:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));

	@synchronized(self) {
		if (_gObject != NULL) {
			g_object_set_qdata(_gObject, [OGObject wrapperQuark], NULL);
			// Decrease the reference count on the previously stored GObject.
			// Don't provide reference to self to toggle notify in this case because
			// _gObject is going to be exchanged.
			g_object_remove_toggle_ref(_gObject, ogo_ref_toggle_notify, nil);
			// Disable the reverse toggle reference be decreasing our own reference
			// count.
			[self release];
		}

		_gObject = obj;

		if (_gObject != NULL) {
			g_object_set_qdata(_gObject, [OGObject wrapperQuark], self);
			// Increase the reference count on the new GObject
			g_object_add_toggle_ref(_gObject, ogo_ref_toggle_notify, self);
			// Enable the reverse toggle reference by increasing our own reference
			// count.
			[self retain];
		}
	}
}

- (GObject *)gObject
{
	return _gObject;
}

- (void)dealloc
{
	@synchronized(self) {
		if (_gObject != NULL) {
			g_object_set_qdata(_gObject, [OGObject wrapperQuark], NULL);
			// Decrease the reference count on the previously stored GObject.
			// Don't provide reference to self to toggle notify because self
			// is going to cease to exist.
			g_object_remove_toggle_ref(_gObject, ogo_ref_toggle_notify, nil);
			_gObject = NULL;
		}
	}
	[super dealloc];
}

@end