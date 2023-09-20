/*
 * SPDX-FileCopyrightText: 2021-2022 Johannes Brakensiek <objfw@devbeejohn.de>
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#import "OGErrorException.h"

@implementation OGErrorException
@synthesize errNo = _errNo;

+ (instancetype)exception
{
	OF_UNRECOGNIZED_SELECTOR
}

- (instancetype)init
{
	OF_INVALID_INIT_METHOD
}

+ (instancetype)exceptionWithGError:(GError *)err;
{
	return [[[self alloc] initWithGError:err] autorelease];
}

- (instancetype)initWithGError:(GError *)err
{
	self = [super init];

	@try {
		_gDomain = err->domain;
		_errNo = err->code;
		_message = [[OFString alloc] initWithUTF8String:err->message];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[_message release];

	[super dealloc];
}

- (OFString *)description
{
	return [OFString
	    stringWithFormat:@"An exception of type %@ occurred!\nDomain: %@, "
	                     @"Error-Code %i.\nMessage: %@",
	    self.class, self.domain, _errNo, _message];
}

- (OFString *)domain
{
	return [OFString stringWithUTF8String:g_quark_to_string(_gDomain)];
}

@end
