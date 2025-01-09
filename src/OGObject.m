/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2024 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-FileCopyrightText: 2024 Amrit Bhogal <ambhogal01@gmail.com>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObject.h"
#import "OGObjectInitializationFailedException.h"
#import "OGObjectInitializationRaceConditionException.h"
#import "OGObjectInitializationWrappedObjectAlreadySetException.h"
#import "OGObjectSignalNotFoundException.h"

// Signalling
struct SigData {
	id target;
	SEL sel;
	id emitter;
};

static void free_malloced_ptr(gpointer target, GClosure *cl) { free(target); }

static void gsignal_handler(gpointer target, struct SigData *data)
{
	[data->target performSelector:data->sel withObject:data->emitter];
}

// Wrapping memory management
static OFString const *OGObjectQuarkName = @"ogobject-objc-wrapper";
static GQuark OGObjectQuark = 0;

static void refToggleNotify(gpointer data, GObject *object, gboolean is_last_ref)
{
	g_assert(data != NULL);
	g_assert(object != NULL);
	id wrapperObject = (id)data;

	if (wrapperObject != nil) {
		@synchronized(wrapperObject) {
			// OFLog(@"Retain count of object type %@ is %i", [wrapperObject class],
			//     [wrapperObject retainCount]);

			if (!is_last_ref && object != NULL)
				[wrapperObject retain];
			else if (is_last_ref && object != NULL)
				[wrapperObject release];
		}
	}
}

static void initObjectQuark(void)
{
	OGObjectQuark = g_quark_from_string([OGObjectQuarkName UTF8String]);
}

id OGWrapperClassAndObjectForGObject(void *obj)
{
	g_assert(G_IS_OBJECT(obj));

	Class wrapperClass = g_type_get_qdata(G_OBJECT_TYPE(obj), [OGObject wrapperQuark]);

	while (wrapperClass == Nil) {
		GType parentType = g_type_parent(G_OBJECT_TYPE(obj));
		// Fundamental type reached
		if (parentType == 0) {
			wrapperClass = [OGObject class];
			break;
		}
		wrapperClass = g_type_get_qdata(parentType, [OGObject wrapperQuark]);
	}

	return [wrapperClass withGObject:obj];
}

@implementation OGObject

+ (void)load
{
	GType gtypeToAssociate = G_TYPE_OBJECT;

	if (gtypeToAssociate == 0)
		return;

	g_type_set_qdata(gtypeToAssociate, [self wrapperQuark], [self class]);
}

+ (GQuark)wrapperQuark
{
	if (OGObjectQuark != 0)
		return OGObjectQuark;

	static OFOnceControl onceControl = OFOnceControlInitValue;
	OFOnce(&onceControl, initObjectQuark);

	return OGObjectQuark;
}

+ (instancetype)withGObject:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));

	id retVal = (id)[[self alloc] initWithGObject:obj];
	return [retVal autorelease];
}

- (void)dealloc
{
	@synchronized(self) {
		if (_gObject != NULL) {
			g_object_replace_qdata(
			    _gObject, [OGObject wrapperQuark], self, NULL, NULL, NULL);

			// Decrease the reference count on the previously stored GObject.
			// Don't provide reference to self to toggle notify because self
			// is going to cease to exist.
			g_object_remove_toggle_ref(_gObject, refToggleNotify, nil);
			_gObject = NULL;
		}
	}
	[super dealloc];
}

- (instancetype)initWithGObject:(void *)obj
{
	g_assert(G_IS_OBJECT(obj));

	self = [super init];

	@synchronized(self) {
		@try {
			if (obj == NULL)
				@throw [OGObjectInitializationFailedException
				    exceptionWithClass:[self class]];

			GQuark quark = [[self class] wrapperQuark];

			id wrapperObject = g_object_get_qdata(obj, quark);
			if ([wrapperObject isKindOfClass:[self class]]) {
				[self release];
				return wrapperObject;
			}

			[self setGObject:obj];
			[self retain];
		} @catch (id e) {
			[self release];
			@throw e;
		}
	}

	return self;
}

- (void)setGObject:(void *)obj
{
	@synchronized(self) {
		if (_gObject != NULL && obj != NULL) {
			@throw [OGObjectInitializationWrappedObjectAlreadySetException
			    exceptionWithClass:[self class]];
		}

		_gObject = obj;

		if (_gObject != NULL) {
			g_assert(G_IS_OBJECT(_gObject));

			if (!g_object_replace_qdata(
			        _gObject, [OGObject wrapperQuark], NULL, self, NULL, NULL))
				@throw [OGObjectInitializationRaceConditionException
				    exceptionWithClass:[self class]];

			// Increase the reference count on the new GObject
			g_object_add_toggle_ref(_gObject, refToggleNotify, self);
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

- (gulong)connectSignal:(OFString *)signal target:(id)target selector:(SEL)sel
{
	guint signalId = g_signal_lookup([signal UTF8String], G_OBJECT_TYPE(_gObject));
	if (signalId == 0)
		@throw [OGObjectSignalNotFoundException exceptionWithSignal:signal];

	struct SigData *data = malloc(sizeof(struct SigData));
	data->target = target;
	data->sel = sel;
	data->emitter = self;

	return g_signal_connect_data(
	    _gObject, [signal UTF8String], G_CALLBACK(gsignal_handler), data, free_malloced_ptr, 0);
}

@end
