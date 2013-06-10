//
//  Geocoder.h
//
//  Created by ChainSysMac on 07/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol GeocoderDelegate

-(void)locationFoundWithMapRegion:(MKCoordinateRegion)region;

@end


@interface Geocoder : NSObject 
{
	id<GeocoderDelegate> delegate;
	NSMutableData *receivedData;
}

-(void)getCoordinateForAddress:(NSString*)address;


@property (assign) id<GeocoderDelegate> delegate;

@end
