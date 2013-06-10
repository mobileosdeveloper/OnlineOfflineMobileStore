//
//  PlaceMark.m
//  Created by ChainSysMac on 07/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.

#import "PlaceMark.h"


@implementation PlaceMark

@synthesize coordinate;
@synthesize place;

-(id) initWithPlace: (Place*) p
{
	self = [super init];
	if (self != nil) {
		coordinate.latitude = p.latitude;
		coordinate.longitude = p.longitude;
		self.place = p;
	}
	return self;
}

- (NSString *)subtitle
{
	return self.place.description;
}
- (NSString *)title
{
	return self.place.name;
}

- (void) dealloc
{
}


@end
