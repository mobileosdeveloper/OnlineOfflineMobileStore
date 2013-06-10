//  Place.h
//  Created by ChainSysMac on 07/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.

#import <Foundation/Foundation.h>


@interface Place : NSObject {

	NSString* name;
	NSString* description;
	double latitude;
	double longitude;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
