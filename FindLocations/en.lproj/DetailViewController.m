//
//  DetailViewController.m
//  SalesForcePOC
//
//  Created by ChainSysMac on 29/05/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "DetailViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "PlaceMark.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize Map;

NSArray *records;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Here we use a query that should work on either Force.com or Database.com
    
    self.Map = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.Map.delegate = self;
    self.Map.userInteractionEnabled = YES;
//    self.Map.showsUserLocation = YES;
    self.Map.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    [self.view addSubview:self.Map];
    [[SFRestAPI sharedInstance]setApiVersion:@"v27.0"];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT Id,Name,sureshper__LocationVal__Latitude__s,sureshper__LocationVal__Longitude__s FROM Contact WHERE DISTANCE(sureshper__LocationVal__c, GEOLOCATION(13.5146,80.6596), 'mi') < 50"]];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"expose_title", @"expose_title")
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self.navigationController.exposeController
                                                                              action:@selector(toggleExpose)] autorelease];


}
-(void)SetUserID:(NSString *)UserID
{
    UserIDStr=UserID;
}



-(void)locationFoundWithMapRegion:(MKCoordinateRegion)region
{
	Map.region = region;
    [self zoomMapAndCenterAtLatitude:region.center.latitude andLongitude:region.center.longitude];
    coordinate.latitude=region.center.latitude;
    coordinate.longitude=region.center.longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = [[records objectAtIndex:0] valueForKey:@"Name"];
    [Map addAnnotation:annotation];

}

-(void)zoomMapAndCenterAtLatitude:(double) latitude andLongitude:(double) longitude
{
    MKCoordinateRegion region;
    region.center.latitude  = latitude;
    region.center.longitude = longitude;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    span.latitudeDelta  = .05;
    span.longitudeDelta = .05;
    region.span = span;
    Map.region=region;
    //Move the map and zoom
}

-(void) centerMap:(NSArray *)SelectedLocations

{
	MKCoordinateRegion region;
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 120;
	CLLocationDegrees minLon = 150;
	NSMutableArray *temp=[NSArray arrayWithArray:SelectedLocations];
	NSLog(@"%@",temp);
    
	for (int i=0; i<[temp count];i++) {
        
		Place* home = [[Place alloc] init];
		home.latitude = [[[temp objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Latitude__s"] floatValue];
		home.longitude =[[[temp objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Longitude__s"] floatValue];
		
		PlaceMark* from = [[PlaceMark alloc]initWithPlace:home];
		
		CLLocation* currentLocation = (CLLocation*)from ;
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
		
		region.center.latitude     = (maxLat + minLat) / 2;
		region.center.longitude    = (maxLon + minLon) / 2;
		region.span.latitudeDelta  =  0.8;
		region.span.longitudeDelta = 0.8;
	}
    
	[self.Map setRegion:region animated:YES];
	
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %@", records);
    [records retain];
//    Geocoder *geocoder = [[[Geocoder alloc] init] autorelease];
//	geocoder.delegate = self;
//    if ([[[records objectAtIndex:0] valueForKey:@"MailingStreet"]isKindOfClass:[NSString class]])
//    {
//	[geocoder getCoordinateForAddress:[[records objectAtIndex:0] valueForKey:@"MailingStreet"]];
//	}
    
   // [self zoomMapAndCenterAtLatitude:[[[records objectAtIndex:0] valueForKey:@"sureshper__LocationVal__Latitude__s"] floatValue] andLongitude:[[[records objectAtIndex:0] valueForKey:@"sureshper__LocationVal__Longitude__s"] floatValue]];
    [self centerMap:records];

    for (int i=0; i<[records count]; i++) {
        
    //[self zoomMapAndCenterAtLatitude:[[[records objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Latitude__s"] floatValue] andLongitude:[[[records objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Longitude__s"] floatValue]];
    coordinate.latitude=[[[records objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Latitude__s"] floatValue];
    coordinate.longitude=[[[records objectAtIndex:i] valueForKey:@"sureshper__LocationVal__Longitude__s"] floatValue];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = [[records objectAtIndex:i] valueForKey:@"Name"];
    [Map addAnnotation:annotation];
    }

    
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return Nil;
    }
    
    
    NSLog(@"----- &&  %@",annotation);

    
    
    MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:Nil];
    customPinView.pinColor = MKPinAnnotationColorPurple;
    customPinView.animatesDrop = YES;
    customPinView.canShowCallout = YES;
    

    
    
//    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    [rightButton addTarget:self
//                    action:@selector(showDetails:)
//          forControlEvents:UIControlEventTouchUpInside];
//    customPinView.rightCalloutAccessoryView = rightButton;
    
    return customPinView;
    
    
    
    
//    if([Map.annotations count]>1)
//    {
//        [Map removeAnnotation:annotation];
//        return nil;
//        
//    }
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
