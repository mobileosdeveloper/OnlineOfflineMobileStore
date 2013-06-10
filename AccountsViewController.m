//
//  AccountsViewController.m
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "AccountsViewController.h"
#import "LIExposeController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SFNativeRestAppDelegate.h"
#import "SFSmartStore.h"
#import "SFSoupQuerySpec.h"
#import "JSON.h"
@interface AccountsViewController ()

@end

@implementation AccountsViewController
@synthesize dataRows;

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
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self.navigationController.exposeController
                                                                              action:@selector(toggleExpose)] autorelease];

    
    
    // Do any additional setup after loading the view from its nib.
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id,Name FROM Account"];
    //WHERE DISTANCE(sureshper__LocationVal__c, GEOLOCATION(13.5146,80.6596), 'mi') < 50
    [[SFRestAPI sharedInstance] send:request delegate:self];
    
}


#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSArray *records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %d", records.count);
    self.dataRows = records;
    [tableView reloadData];
    
    NSError *error = nil;
    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    if ([records count]) {
        [store upsertEntries:records toSoup:@"AccountSoup" withExternalIdPath:@"Id" error:&error];
        
    }
    
    
    
    NSMutableDictionary *queryDictionary = [[ NSMutableDictionary alloc] init];
    
    
    [queryDictionary setObject:@"range" forKey:@"queryType"];
    [queryDictionary setObject:@"Name" forKey:@"indexPath"];
    [queryDictionary setObject:@"ascending" forKey:@"order"];
    [queryDictionary setObject:[NSNumber numberWithInt:500] forKey:@"pageSize"];
    
    
    
    SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionary];
    
    NSArray *results = [store querySoup:@"AccountSoup" withQuerySpec:querySpec pageIndex:0];
    
    self.dataRows = results;
    [tableView reloadData];
    [queryDictionary release];
    [querySpec release];
    
    
    
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    
    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    
    NSMutableDictionary *queryDictionary = [[ NSMutableDictionary alloc] init];
    
    
    [queryDictionary setObject:@"range" forKey:@"queryType"];
    [queryDictionary setObject:@"Name" forKey:@"indexPath"];
    [queryDictionary setObject:@"ascending" forKey:@"order"];
    [queryDictionary setObject:[NSNumber numberWithInt:500] forKey:@"pageSize"];
    
    
    
    SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionary];
    
    NSArray *results = [store querySoup:@"AccountSoup" withQuerySpec:querySpec pageIndex:0];
    NSLog(@"requestDidCancelLoad: %@", results);
    
    self.dataRows = results;
    [tableView reloadData];
    [queryDictionary release];
    [querySpec release];
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataRows count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
    }
	//if you want to add an image to your cell, here's how
	UIImage *image = [UIImage imageNamed:@"icon.png"];
	cell.imageView.image = image;
    
	// Configure the cell to show the data.
	NSDictionary *obj = [dataRows objectAtIndex:indexPath.row];
	cell.textLabel.text =  [obj objectForKey:@"Name"];
    
	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *DetailViewControllerObj=[[DetailViewController alloc]init];
    //    [DetailViewControllerObj SetUserID:[[dataRows objectAtIndex:indexPath.row] valueForKey:@"Id"]];
    //    [self.navigationController pushViewController:DetailViewControllerObj animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
