#import <ObjFW/ObjFW.h>
#import <OGEBookContacts/OGEBookContacts-Umbrella.h>

@interface MemoryTest: OFObject <OFApplicationDelegate>
@end

OF_APPLICATION_DELEGATE(MemoryTest)

@implementation MemoryTest
- (void)applicationDidFinishLaunching: (OFNotification *)notification
{
	OFLog(@"Test series 1: Freeing memory via the mapper object.");
	EContact *gecontact = E_CONTACT(e_contact_new());
	g_object_add_weak_pointer (G_OBJECT (gecontact), (gpointer *) &gecontact);

	OFLog(@"Starting ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	
	OFLog(@"Creating a wrapper for GObject…");
	OGEContact *myWrapper = [OGEContact wrapperFor:gecontact];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Retaining wrapper…", nil);
	[myWrapper retain];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Releasing wrapper…", nil);
	[myWrapper release];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Releasing wrapper…", nil);
	[myWrapper release];
	OFLog(@"GObject is NULL: %u", (gecontact == NULL));

	OFLog(@"Test series 2: Freeing memory via the gobject.");
	gecontact = E_CONTACT(e_contact_new());
	g_object_add_weak_pointer (G_OBJECT (gecontact), (gpointer *) &gecontact);

	OFLog(@"Starting ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	
	OFLog(@"Creating a wrapper for GObject…");
	myWrapper = [OGEContact wrapperFor:gecontact];
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Refing GObject…", nil);
	g_object_ref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"Ref count of GObject is: %u", (((GObject*)(gecontact))->ref_count));
	OFLog(@"Retain count of the wrapper is: %u", myWrapper.retainCount);

	OFLog(@"Unrefing GObject…", nil);
	g_object_unref(gecontact);
	OFLog(@"GObject is NULL: %u", (gecontact == NULL));

	[OFApplication terminate];
}
@end
