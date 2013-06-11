//
//  ContactsViewController.m
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "ContactsViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SFNativeRestAppDelegate.h"
#import "SFSmartStore.h"
#import "SFSoupQuerySpec.h"
#import "JSON.h"
#import "LIExposeController.h"
#import "AddEditViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"
@interface ContactsViewController ()

@end

@implementation ContactsViewController
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
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                               style:UIBarButtonItemStyleBordered
                                                                              target:self.navigationController.exposeController
                                                                              action:@selector(toggleExpose)] autorelease];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContacts:)];

    // Do any additional setup after loading the view from its nib.
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refreshControl];

}
-(void)handleRefresh:(id)sender
{
    [self Syncwithsalesforce];
}
-(void)viewWillAppear:(BOOL)animated{

    [self Syncwithsalesforce];
}

-(void)Syncwithsalesforce
{
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability:internetReach];
    
    
    NSMutableDictionary *queryDictionaryQueue = [[ NSMutableDictionary alloc] init];
    
    
    [queryDictionaryQueue setObject:@"range" forKey:@"queryType"];
    [queryDictionaryQueue setObject:@"Name" forKey:@"indexPath"];
    [queryDictionaryQueue setObject:@"ascending" forKey:@"order"];
    [queryDictionaryQueue setObject:[NSNumber numberWithInt:500] forKey:@"pageSize"];
    
    if (APP.offLineMode) {
        
        
        SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionaryQueue];
        SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
        
        NSArray *results = [store querySoup:@"Merchandise" withQuerySpec:querySpec pageIndex:0];
        
        self.dataRows = results;
        [tableView reloadData];
        [querySpec release];
        
        
        
    }
    
    else{
        
        SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionaryQueue];
        SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
        
        NSArray *results = [store querySoup:@"ContactsQueue" withQuerySpec:querySpec pageIndex:0];
        NSLog(@"results ContactsQueue %@",results);
        if ([results count]>0) {
            for (NSArray *object in results) {
                NSLog(@"Object %@",[object valueForKey:@"FirstName"]);
                
                
                NSDictionary *fields = [[NSString stringWithFormat:@"{\"FirstName\":\"%@\", \"LastName\":\"%@\",\"AssistantName\":\"%@\", \"Title\":\"%@\",\"MailingStreet\":\"%@\", \"MailingCity\":\"%@\",\"MailingState\":\"%@\", \"MailingPostalCode\":\"%@\",\"MailingCountry\":\"%@\", \"Phone\":\"%@\",\"MobilePhone\":\"%@\", \"Email\":\"%@\",\"Department\":\"%@\", \"OtherStreet\":\"%@\",\"OtherCity\":\"%@\", \"OtherState\":\"%@\",\"OtherPostalCode\":\"%@\",\"OtherCountry\":\"%@\"}",[object valueForKey:@"FirstName"],[object valueForKey:@"LastName"],[object valueForKey:@"Account"],[object valueForKey:@"Title"],[object valueForKey:@"MailingStreet"],[object valueForKey:@"MailingCity"],[object valueForKey:@"MailingState"],[object valueForKey:@"MailingPostalCode"],[object valueForKey:@"MailingCountry"],[object valueForKey:@"Phone"],[object valueForKey:@"MobilePhone"],[object valueForKey:@"Email"],[object valueForKey:@"Birthdate"],[object valueForKey:@"OtherStreet"],[object valueForKey:@"OtherCity"],[object valueForKey:@"OtherState"],[object valueForKey:@"OtherPostalCode"],[object valueForKey:@"OtherCountry"]] JSONValue];
                NSLog(@"Values %@",fields);
                
                
                
                SFRestRequest *requestCreate = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Contact" fields:fields];
                
                //send the request
                [[SFRestAPI sharedInstance] send:requestCreate delegate:self];
            }
            [store removeEntries:[results valueForKey:@"_soupEntryId"] fromSoup:@"ContactsQueue"];
            
        }
        
        
        // Delete
        
        
        NSArray *resultsDelete = [store querySoup:@"ContactsDeleteQueue" withQuerySpec:querySpec pageIndex:0];
        NSLog(@"results ContactsQueue %@",resultsDelete);
        if ([resultsDelete count]>0) {
            for (NSArray *object in resultsDelete) {
                NSLog(@"Object %@",object);
                
                
                
                SFRestRequest *requestDelete = [[SFRestAPI sharedInstance] requestForDeleteWithObjectType:@"Contact" objectId:[object valueForKey:@"Name"]];
                
                //send the request
                [[SFRestAPI sharedInstance] send:requestDelete delegate:self];
            }
            [store removeEntries:[resultsDelete valueForKey:@"_soupEntryId"] fromSoup:@"ContactsDeleteQueue"];
            
        }
        
        // Edit
        
        NSArray *resultsEdit = [store querySoup:@"ContactsEditQueue" withQuerySpec:querySpec pageIndex:0];
        NSLog(@"results ContactsEditQueue %@",resultsEdit);
        if ([resultsEdit count]>0) {
            for (NSArray *object in resultsEdit) {
                NSLog(@"Object %@",object);
                
                NSDictionary *fields = [[NSString stringWithFormat:@"{\"FirstName\":\"%@\", \"LastName\":\"%@\",\"AssistantName\":\"%@\", \"Title\":\"%@\",\"MailingStreet\":\"%@\", \"MailingCity\":\"%@\",\"MailingState\":\"%@\", \"MailingPostalCode\":\"%@\",\"MailingCountry\":\"%@\", \"Phone\":\"%@\",\"MobilePhone\":\"%@\", \"Email\":\"%@\",\"Department\":\"%@\", \"OtherStreet\":\"%@\",\"OtherCity\":\"%@\", \"OtherState\":\"%@\",\"OtherPostalCode\":\"%@\",\"OtherCountry\":\"%@\"}",[object valueForKey:@"FirstName"],[object valueForKey:@"LastName"],[object valueForKey:@"Account"],[object valueForKey:@"Title"],[object valueForKey:@"MailingStreet"],[object valueForKey:@"MailingCity"],[object valueForKey:@"MailingState"],[object valueForKey:@"MailingPostalCode"],[object valueForKey:@"MailingCountry"],[object valueForKey:@"Phone"],[object valueForKey:@"MobilePhone"],[object valueForKey:@"Email"],[object valueForKey:@"Birthdate"],[object valueForKey:@"OtherStreet"],[object valueForKey:@"OtherCity"],[object valueForKey:@"OtherState"],[object valueForKey:@"OtherPostalCode"],[object valueForKey:@"OtherCountry"]] JSONValue];
                NSLog(@"Values %@",fields);
                
                
                SFRestRequest *requestEdit = [[SFRestAPI sharedInstance]requestForUpdateWithObjectType:@"Contact" objectId:[object valueForKey:@"Id"] fields:fields];
                
                //send the request
                [[SFRestAPI sharedInstance] send:requestEdit delegate:self];
            }
            [store removeEntries:[resultsEdit valueForKey:@"_soupEntryId"] fromSoup:@"ContactsEditQueue"];
            
        }
        
        
        
        
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id,FirstName,LastName,AssistantName,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,MobilePhone,Email,Department,OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry FROM Contact"];
        //WHERE DISTANCE(sureshper__LocationVal__c, GEOLOCATION(13.5146,80.6596), 'mi') < 50
        [[SFRestAPI sharedInstance] send:request delegate:self];
        [querySpec release];
        
    }
    
    [queryDictionaryQueue release];

}
-(void)addNewContacts:(id)sender{
    
        AddEditViewController *AddEditViewControllerObj=[[AddEditViewController alloc]init];
        [AddEditViewControllerObj ContactViewState:NO UserID:nil SoupEntryId:nil];
        self.navigationController.title=@"Add New";
        [self.navigationController pushViewController:AddEditViewControllerObj animated:YES];

}
#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSArray *records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %d", records.count);
    if ([records count]<=0) {
        return;
    }
//    self.dataRows = records;
//    [tableView reloadData];
    
    NSMutableDictionary *queryDictionary = [[ NSMutableDictionary alloc] init];
    
    
    [queryDictionary setObject:@"range" forKey:@"queryType"];
    [queryDictionary setObject:@"Name" forKey:@"indexPath"];
    [queryDictionary setObject:@"ascending" forKey:@"order"];
    [queryDictionary setObject:[NSNumber numberWithInt:500] forKey:@"pageSize"];
    
    
    NSError *error = nil;
    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];

    SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionary];
    
    NSArray *results = [store querySoup:@"Merchandise" withQuerySpec:querySpec pageIndex:0];

    
    
    if ([records count]) {
        [store removeEntries:[results valueForKey:@"_soupEntryId"] fromSoup:@"Merchandise"];
        [store upsertEntries:records toSoup:@"Merchandise" withExternalIdPath:@"Id" error:&error];
        
    }
    
    
    
    results = [store querySoup:@"Merchandise" withQuerySpec:querySpec pageIndex:0];
    
    self.dataRows = results;
    [tableView reloadData];
    
    [refreshControl endRefreshing];

    [queryDictionary release];
    [querySpec release];
    

    
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here

    
    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];

    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    
    NSMutableDictionary *queryDictionary = [[ NSMutableDictionary alloc] init];
    
    
    [queryDictionary setObject:@"range" forKey:@"queryType"];
    [queryDictionary setObject:@"Name" forKey:@"indexPath"];
    [queryDictionary setObject:@"ascending" forKey:@"order"];
    [queryDictionary setObject:[NSNumber numberWithInt:500] forKey:@"pageSize"];
    
    
    
    SFSoupQuerySpec *querySpec = [[SFSoupQuerySpec alloc] initWithDictionary:queryDictionary];
    
    NSArray *results = [store querySoup:@"Merchandise" withQuerySpec:querySpec pageIndex:0];
    NSLog(@"requestDidCancelLoad: %@", results);
    
    self.dataRows = results;
    [tableView reloadData];
    [refreshControl endRefreshing];

    [queryDictionary release];
    [querySpec release];
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    [refreshControl endRefreshing];

    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    [refreshControl endRefreshing];

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
	cell.textLabel.text =  [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"FirstName"],[obj objectForKey:@"LastName"]];
    
	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddEditViewController *AddEditViewControllerObj=[[AddEditViewController alloc]init];
    [AddEditViewControllerObj ContactViewState:YES UserID:[[dataRows objectAtIndex:indexPath.row] valueForKey:@"Id"] SoupEntryId:[[dataRows objectAtIndex:indexPath.row] valueForKey:@"_soupEntryId"]];
    self.navigationController.title=@"Edit";
    [self.navigationController pushViewController:AddEditViewControllerObj animated:YES];

    
}


-(void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    NSString* statusString= @"";
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
            //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Offline Mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [Alert show];
            APP.offLineMode=1;
            break;
        }
            
        case ReachableViaWWAN:
        {
            //            statusString = @"Reachable WWAN";
            //            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Access Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [Alert show];
            APP.offLineMode=0;
            
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
           APP.offLineMode=0;
            
            break;
        }
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
