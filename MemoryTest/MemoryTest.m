#import <ObjFW/ObjFW.h>
#import <OGObject/OGObject.h>

@interface MemoryTest: OFObject <OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(MemoryTest)

@implementation MemoryTest
- (void)applicationDidFinishLaunching: (OFNotification *)notification
{
	OFLog(@"Test series 1: Freeing memory via the mapper object.");
	GObject *gobject = g_object_new(G_TYPE_OBJECT, NULL);
	g_object_add_weak_pointer (G_OBJECT (gobject), (gpointer *) &gobject);

	OFLog(@"Starting ref count of GObject is: %u", gobject->ref_count);
	
	OFLog(@"Creating a wrapper for GObject…");
	OGObject *myWrapper = [[OGObject alloc] init];
	[myWrapper setGObject:gobject];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Retaining wrapper…", nil);
	[myWrapper retain];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Releasing wrapper…", nil);
	[myWrapper release];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Releasing wrapper…", nil);
	[myWrapper release];
	OFLog(@"GObject is NULL: %u", (gobject == NULL));

	OFLog(@"Test series 2: Freeing memory via the gobject.");
	gobject = g_object_new(G_TYPE_OBJECT, NULL);
	g_object_add_weak_pointer (G_OBJECT (gobject), (gpointer *) &gobject);

	OFLog(@"Starting ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	
	OFLog(@"Creating a wrapper for GObject…");
	myWrapper = [[OGObject alloc] init];
	[myWrapper setGObject:gobject];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gobject))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gobject);
	OFLog(@"GObject is NULL: %u", (gobject == NULL));

	[OFApplication terminate];
}
@end
