/*
 * SPDX-FileCopyrightText: 2015-2017 Tyler Burton <software@tylerburton.ca>
 * SPDX-FileCopyrightText: 2021-2025 The ObjGTK authors, see AUTHORS file at https://github.com/ObjGTK/gir2objc/blob/main/AUTHORS
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGObject.h"
#import "OGObjectInitializationFailedException.h"
#import "OGObjectInitializationRaceConditionException.h"
#import "OGObjectInitializationWrappedObjectAlreadySetException.h"
#import "OGObjectSignalNotFoundException.h"
#import <ffi.h>

struct OGClosure {
	GClosure closure;
	SEL sel;
};

static void closure_marshal(GClosure *closure, GValue *return_value, guint n_param_values,
    const GValue *param_values, gpointer invocation_hint, gpointer marshal_data)
{
	struct OGClosure *og_closure = (struct OGClosure *)closure;
	ffi_cif cif;
	ffi_type **arg_types = g_newa(ffi_type *, 2 + n_param_values);
	void **objc_arg_values = g_newa(void *, 2 + n_param_values);
	void **objc_arg_value_ptrs = g_newa(void *, 2 + n_param_values);
	ffi_type *ret_type = &ffi_type_void;  // TODO
	ffi_arg rc;
	ffi_status status;
	IMP callee;

	arg_types[0] = &ffi_type_pointer;
	objc_arg_values[0] = closure->data;
	objc_arg_value_ptrs[0] = &objc_arg_values[0];

#if defined(OF_OBJFW_RUNTIME)
	callee = objc_msg_lookup((id)closure->data, og_closure->sel);
	arg_types[1] = &ffi_type_pointer;
#elif defined(OF_APPLE_RUNTIME)
	callee = objc_msgSend;
	arg_types[1] = &ffi_type_pointer;
#else
#error Need support for that runtime
#endif

	objc_arg_values[1] = (void *)og_closure->sel;
	objc_arg_value_ptrs[1] = &objc_arg_values[1];

	for (int i = 0; i < n_param_values; i++) {
		const GValue *gvalue = &param_values[i];
		if (G_VALUE_HOLDS(gvalue, G_TYPE_INT) || G_VALUE_HOLDS(gvalue, G_TYPE_ENUM) ||
		    G_VALUE_HOLDS(gvalue, G_TYPE_FLAGS)) {
			int v = g_value_get_int(gvalue);
			arg_types[2 + i] = &ffi_type_sint;
			memcpy(&objc_arg_values[2 + i], &v, sizeof(v));
		} else if (G_VALUE_HOLDS(gvalue, G_TYPE_DOUBLE)) {
			double d = g_value_get_double(gvalue);
			arg_types[2 + i] = &ffi_type_double;
			memcpy(&objc_arg_values[2 + i], &d, sizeof(d));
		} else if (G_VALUE_HOLDS(gvalue, G_TYPE_FLOAT)) {
			float f = g_value_get_float(gvalue);
			arg_types[2 + i] = &ffi_type_float;
			memcpy(&objc_arg_values[2 + i], &f, sizeof(f));
		} else if (G_VALUE_HOLDS(gvalue, G_TYPE_BOOLEAN)) {
			uint8_t b = (uint8_t)g_value_get_boolean(gvalue);
			arg_types[2 + i] = &ffi_type_uint8;
			memcpy(&objc_arg_values[2 + i], &b, sizeof(b));
		} else if (G_VALUE_HOLDS(gvalue, G_TYPE_POINTER)) {
			void *p = g_value_get_pointer(gvalue);
			arg_types[2 + i] = &ffi_type_pointer;
			objc_arg_values[2 + i] = p;
		} else if (G_VALUE_HOLDS(gvalue, G_TYPE_OBJECT)) {
			void *obj = g_value_get_object(gvalue);
			id wrapper = OGWrapperClassAndObjectForGObject(obj);
			arg_types[2 + i] = &ffi_type_pointer;
			objc_arg_values[2 + i] = wrapper;
		} else {
			abort();
			// TODO throw a new Exception here
		}
		objc_arg_value_ptrs[2 + i] = &objc_arg_values[2 + i];
	}

	// TODO: consider doing this at connect time rather than at emit time.
	status = ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 2 + n_param_values, ret_type, arg_types);
	OFAssert(status == FFI_OK);

	ffi_call(&cif, FFI_FN(callee), &rc, objc_arg_value_ptrs);

	// TODO save the return value
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

- (instancetype)init
{
	OF_INVALID_INIT_METHOD
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
	return [self connectSignal:signal target:target selector:sel after:false];
}

- (gulong)connectSignal:(OFString *)signal
                 target:(id)target
               selector:(SEL)sel
                  after:(bool)connectAfter
{
	guint signalId = g_signal_lookup([signal UTF8String], G_OBJECT_TYPE(_gObject));
	if (signalId == 0)
		@throw [OGObjectSignalNotFoundException exceptionWithSignal:signal];

	GClosure *closure = g_closure_new_simple(sizeof(struct OGClosure), target);
	struct OGClosure *og_closure = (struct OGClosure *)closure;
	og_closure->sel = sel;
	g_closure_set_marshal(closure, closure_marshal);

	if ([target isKindOfClass:[OGObject class]]) {
		GObject *obj = [target gObject];
		if (obj)
			g_object_watch_closure(obj, closure);
	}

	return g_signal_connect_closure(_gObject, [signal UTF8String], closure, connectAfter);
}

@end
