//
//  AddEditViewController.m
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "AddEditViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "DetailViewController.h"
#import "SFNativeRestAppDelegate.h"
#import "SFSmartStore.h"
#import "SFSoupQuerySpec.h"
#import "JSON.h"
#import "AppDelegate.h"

@interface AddEditViewController ()

@end

@implementation AddEditViewController
@synthesize FirstName;
@synthesize LastName;
@synthesize contactFieldValuesObj;
@synthesize dataRows;
@synthesize AccountsPickerView;
@synthesize AccountsView;
@synthesize DatePickerView;
@synthesize DateView;
@synthesize tableview;
NSDictionary *fields;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        contactFieldValuesObj=[[contactFieldValues alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CurrentIndexPathArray=[[NSMutableArray alloc]init];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addNewContacts:)];

    if (APP.offLineMode==NO) {
        
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name FROM Account"];
    //WHERE DISTANCE(sureshper__LocationVal__c, GEOLOCATION(13.5146,80.6596), 'mi') < 50
    [[SFRestAPI sharedInstance] send:request delegate:self];
      }
    else{
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

    }
    
}

-(void)ContactViewState:(BOOL)ContactEditFlagObj UserID:(NSString *)UserIdObj SoupEntryId:(NSString *)SoupEntryIdObj {
    
    contactEditFlag=ContactEditFlagObj;
    UserId=UserIdObj;
    SoupEntryId=SoupEntryIdObj;
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability:internetReach];

        if (APP.offLineMode==YES) {
            SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
            
             self.dataRows= [store retrieveEntries:[[NSArray alloc]initWithObjects:SoupEntryId, nil] fromSoup:@"Merchandise"];
            if ([[dataRows valueForKey:@"FirstName"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.firstName=[[dataRows valueForKey:@"FirstName"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"LastName"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.lastName=[[dataRows valueForKey:@"LastName"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"AssistantName"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.accountName=[[dataRows valueForKey:@"AssistantName"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"Title"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.title=[[dataRows valueForKey:@"Title"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"MailingStreet"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mailingStreet=[[dataRows valueForKey:@"MailingStreet"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"MailingCity"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mailingCity=[[dataRows valueForKey:@"MailingCity"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"MailingState"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mailingState=[[dataRows valueForKey:@"MailingState"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"MailingPostalCode"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mailingZip=[[dataRows valueForKey:@"MailingPostalCode"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"MailingCountry"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mailingCountry=[[dataRows valueForKey:@"MailingCountry"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"Phone"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.phoneNumber=[[dataRows valueForKey:@"Phone"] objectAtIndex:0];
            }
            if ([[dataRows valueForKey:@"MobilePhone"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.mobileNumber=[[dataRows valueForKey:@"MobilePhone"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"Department"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.dateOfBirth=[[dataRows valueForKey:@"Department"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"OtherStreet"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.otherStreet=[[dataRows valueForKey:@"OtherStreet"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"otherCity"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.otherCity=[[dataRows valueForKey:@"otherCity"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"otherState"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.otherState=[[dataRows valueForKey:@"otherState"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"OtherPostalCode"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.otherZip=[[dataRows valueForKey:@"OtherPostalCode"] objectAtIndex:0];

            }
            if ([[dataRows valueForKey:@"OtherCountry"] objectAtIndex:0]!=NULL) {
                contactFieldValuesObj.otherCountry=[[dataRows valueForKey:@"OtherCountry"] objectAtIndex:0];

            }
            

            [tableview reloadData];
        }
        else{
            if (UserId!=nil) {

        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT Id,FirstName,LastName,AssistantName,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Phone,MobilePhone,Email,Department,OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry FROM Contact WHERE Id='%@'",UserId]];
        //WHERE DISTANCE(sureshper__LocationVal__c, GEOLOCATION(13.5146,80.6596), 'mi') < 50
        [[SFRestAPI sharedInstance] send:request delegate:self];
      }
        }
    

}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSArray *records = [jsonResponse objectForKey:@"records"];
    
    if ([[[[records valueForKey:@"attributes"]valueForKey:@"type"] objectAtIndex:0] isEqual:@"Contact"]) {
        NSLog(@"Contact receive ------");
        NSLog(@"request:didLoadResponse: #records: %@", records);
        contactFieldValuesObj.firstName=[[records valueForKey:@"FirstName"] objectAtIndex:0];
        contactFieldValuesObj.lastName=[[records valueForKey:@"LastName"] objectAtIndex:0];
        contactFieldValuesObj.accountName=[[records valueForKey:@"AssistantName"] objectAtIndex:0];
        contactFieldValuesObj.title=[[records valueForKey:@"Title"] objectAtIndex:0];
        contactFieldValuesObj.mailingStreet=[[records valueForKey:@"MailingStreet"] objectAtIndex:0];
        contactFieldValuesObj.mailingCity=[[records valueForKey:@"MailingCity"] objectAtIndex:0];
        contactFieldValuesObj.mailingState=[[records valueForKey:@"MailingState"] objectAtIndex:0];
        contactFieldValuesObj.mailingZip=[[records valueForKey:@"MailingPostalCode"] objectAtIndex:0];
        contactFieldValuesObj.mailingCountry=[[records valueForKey:@"MailingCountry"] objectAtIndex:0];
        contactFieldValuesObj.phoneNumber=[[records valueForKey:@"Phone"] objectAtIndex:0];
        contactFieldValuesObj.mobileNumber=[[records valueForKey:@"MobilePhone"] objectAtIndex:0];
        contactFieldValuesObj.eMail=[[records valueForKey:@"Email"] objectAtIndex:0];
        contactFieldValuesObj.dateOfBirth=[[records valueForKey:@"Department"] objectAtIndex:0];
        contactFieldValuesObj.otherStreet=[[records valueForKey:@"OtherStreet"] objectAtIndex:0];
        contactFieldValuesObj.otherCity=[[records valueForKey:@"otherCity"] objectAtIndex:0];
        contactFieldValuesObj.otherState=[[records valueForKey:@"otherState"] objectAtIndex:0];
        contactFieldValuesObj.otherZip=[[records valueForKey:@"OtherPostalCode"] objectAtIndex:0];
        contactFieldValuesObj.otherCountry=[[records valueForKey:@"OtherCountry"] objectAtIndex:0];
    }
    else{
    
        NSLog(@"Account receive ------");

    NSLog(@"request:didLoadResponse: #records: %@", records);
    self.dataRows = records;
    
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
    [queryDictionary release];
    [querySpec release];
        
    }

    [tableview reloadData];

    
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
    
    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Alert show];

    
    

}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);

    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

#pragma mark - addNewContacts


-(void)addNewContacts:(id)sender{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    if ([contactFieldValuesObj.firstName length]==0) {
        
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter the First Name field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];

    }
    else if([contactFieldValuesObj.lastName length]==0){
        UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please Enter the Last Name field" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [Alert show];

    }
    else if([contactFieldValuesObj.eMail length]>0 && [emailTest evaluateWithObject:contactFieldValuesObj.eMail]!= YES){
        

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];

    }
    else{

    
    if (APP.offLineMode) {
        NSDictionary *fields = [[NSString stringWithFormat:@"{\"FirstName\":\"%@\", \"LastName\":\"%@\",\"Account\":\"%@\", \"Title\":\"%@\",\"MailingStreet\":\"%@\", \"MailingCity\":\"%@\",\"MailingState\":\"%@\", \"MailingPostalCode\":\"%@\",\"MailingCountry\":\"%@\", \"Phone\":\"%@\",\"MobilePhone\":\"%@\", \"Email\":\"%@\",\"Birthdate\":\"%@\", \"OtherStreet\":\"%@\",\"OtherCity\":\"%@\", \"OtherState\":\"%@\",\"OtherPostalCode\":\"%@\",\"OtherCountry\":\"%@\",\"UId\":\"%@\",\"_soupEntryId\":\"%@\"}",contactFieldValuesObj.firstName,contactFieldValuesObj.lastName,contactFieldValuesObj.accountName,contactFieldValuesObj.title,contactFieldValuesObj.mailingStreet,contactFieldValuesObj.mailingCity,contactFieldValuesObj.mailingState,contactFieldValuesObj.mailingZip,contactFieldValuesObj.mailingCountry,contactFieldValuesObj.phoneNumber,contactFieldValuesObj.mobileNumber,contactFieldValuesObj.eMail,contactFieldValuesObj.dateOfBirth,contactFieldValuesObj.otherStreet,contactFieldValuesObj.otherCity,contactFieldValuesObj.otherState,contactFieldValuesObj.otherZip,contactFieldValuesObj.otherCountry,UserId,SoupEntryId] JSONValue];
//        NSDictionary *fieldsMerchandise = [[NSString stringWithFormat:@"{\"Name\":\"%@ %@\"}",FirstName,LastName] JSONValue];
        
        NSDictionary *fieldsMerchandise = [[NSString stringWithFormat:@"{\"FirstName\":\"%@\", \"LastName\":\"%@\",\"Account\":\"%@\", \"Title\":\"%@\",\"MailingStreet\":\"%@\", \"MailingCity\":\"%@\",\"MailingState\":\"%@\", \"MailingPostalCode\":\"%@\",\"MailingCountry\":\"%@\", \"Phone\":\"%@\",\"MobilePhone\":\"%@\", \"Email\":\"%@\",\"Birthdate\":\"%@\", \"OtherStreet\":\"%@\",\"OtherCity\":\"%@\", \"OtherState\":\"%@\",\"OtherPostalCode\":\"%@\",\"OtherCountry\":\"%@\",\"_soupEntryId\":\"%@\"}",contactFieldValuesObj.firstName,contactFieldValuesObj.lastName,contactFieldValuesObj.accountName,contactFieldValuesObj.title,contactFieldValuesObj.mailingStreet,contactFieldValuesObj.mailingCity,contactFieldValuesObj.mailingState,contactFieldValuesObj.mailingZip,contactFieldValuesObj.mailingCountry,contactFieldValuesObj.phoneNumber,contactFieldValuesObj.mobileNumber,contactFieldValuesObj.eMail,contactFieldValuesObj.dateOfBirth,contactFieldValuesObj.otherStreet,contactFieldValuesObj.otherCity,contactFieldValuesObj.otherState,contactFieldValuesObj.otherZip,contactFieldValuesObj.otherCountry,SoupEntryId] JSONValue];
        NSError *error=nil;
        
        SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
        if (fields) {
            [store upsertEntries:[[NSArray alloc]initWithObjects:fieldsMerchandise, nil] toSoup:@"Merchandise" withExternalIdPath:@"_soupEntryId" error:&error ];
            if (contactEditFlag==YES) {

            [store upsertEntries:[[NSArray alloc]initWithObjects:fields, nil] toSoup:@"ContactsEditQueue" withExternalIdPath:@"_soupEntryId" error:&error];
            }
            else{
                [store upsertEntries:[[NSArray alloc]initWithObjects:fields, nil] toSoup:@"ContactsQueue" withExternalIdPath:@"_soupEntryId" error:&error];

            }
        }

    }
    else{
        
        NSDictionary *fields = [[NSString stringWithFormat:@"{\"FirstName\":\"%@\", \"LastName\":\"%@\",\"AssistantName\":\"%@\", \"Title\":\"%@\",\"MailingStreet\":\"%@\", \"MailingCity\":\"%@\",\"MailingState\":\"%@\", \"MailingPostalCode\":\"%@\",\"MailingCountry\":\"%@\", \"Phone\":\"%@\",\"MobilePhone\":\"%@\", \"Email\":\"%@\",\"Department\":\"%@\", \"OtherStreet\":\"%@\",\"OtherCity\":\"%@\", \"OtherState\":\"%@\",\"OtherPostalCode\":\"%@\",\"OtherCountry\":\"%@\"}",contactFieldValuesObj.firstName,contactFieldValuesObj.lastName,contactFieldValuesObj.accountName,contactFieldValuesObj.title,contactFieldValuesObj.mailingStreet,contactFieldValuesObj.mailingCity,contactFieldValuesObj.mailingState,contactFieldValuesObj.mailingZip,contactFieldValuesObj.mailingCountry,contactFieldValuesObj.phoneNumber,contactFieldValuesObj.mobileNumber,contactFieldValuesObj.eMail,contactFieldValuesObj.dateOfBirth,contactFieldValuesObj.otherStreet,contactFieldValuesObj.otherCity,contactFieldValuesObj.otherState,contactFieldValuesObj.otherZip,contactFieldValuesObj.otherCountry] JSONValue];
        NSLog(@"Values %@",fields);
        
        if (contactEditFlag==YES) {
            SFRestRequest *requestUpdate = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Contact" objectId:UserId fields:fields];
            
            //send the request
            [[SFRestAPI sharedInstance] send:requestUpdate delegate:self];

        }
        else{

            SFRestRequest *requestCreate = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Contact" fields:fields];
        
            //send the request
            [[SFRestAPI sharedInstance] send:requestCreate delegate:self];
            
        }

    }
    [self.navigationController popViewControllerAnimated:YES];

        
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (contactEditFlag) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 18;
    }
    else{
        return 1;
    }
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d%d",indexPath.section,indexPath.row];
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
       // [cell setFrame:CGRectMake(5, 20, 320, 100)];

        if (indexPath.section==1) {

            UIButton *deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 0, 290, 45)];
            [deleteButton setTitle:@"delete" forState:UIControlStateNormal];
            [deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteContacts:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteButton];
            
            
        }
        else{

            UILabel  *CellTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, 0, 90, 44)];
            CellTitleLabel.backgroundColor=[UIColor clearColor];
            CellTitleLabel.font = [UIFont systemFontOfSize:12];
            CellTitleLabel.textColor=[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
            CellTitleLabel.textAlignment=NSTextAlignmentLeft;
            
            UITextField *editTextFeild;
            editTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(110, 14, 185, 33)];
            editTextFeild.borderStyle=UITextBorderStyleNone;
            editTextFeild.textAlignment=UITextAlignmentRight;
            editTextFeild.font=[UIFont systemFontOfSize:13];
       
        editTextFeild.tag=indexPath.row;
        if (indexPath.row==0) {

            [CellTitleLabel setText:@"First Name"];

        }
        else if (indexPath.row==1) {
            
      
            [CellTitleLabel setText:@"Last Name"];

        }
        else if (indexPath.row==2) {

            [CurrentIndexPathArray addObject:indexPath];
            [CellTitleLabel setText:@"account name"];

        }

        else if (indexPath.row==3) {
  
            [CellTitleLabel setText:@"title"];

        }

        else if (indexPath.row==4) {

            [CellTitleLabel setText:@"mailing Street"];

        }

        else if (indexPath.row==5) {
            [CellTitleLabel setText:@"mailing City"];

        }

        else if (indexPath.row==6) {
  
            [CellTitleLabel setText:@"mailing state"];

        }

        else if (indexPath.row==7) {

            [CellTitleLabel setText:@"mailing zip code"];

        }
        else if (indexPath.row==8) {
 
            [CellTitleLabel setText:@"mailing country"];

        }
        else if  (indexPath.row==9) {

            [CellTitleLabel setText:@"phone number"];

        }
        else if (indexPath.row==10) {

            [CellTitleLabel setText:@"mobile number"];

        }
        else if (indexPath.row==11) {
 
            [CellTitleLabel setText:@"email"];

        }
        else if (indexPath.row==12) {
 
            [CurrentIndexPathArray addObject:indexPath];
            [CellTitleLabel setText:@"date of birth"];

        }
        else if (indexPath.row==13) {

            [CellTitleLabel setText:@"other street"];

        }
        else if (indexPath.row==14) {

            [CellTitleLabel setText:@"other city"];

        }
        else if (indexPath.row==15) {

            [CellTitleLabel setText:@"other state"];

        }
        else if (indexPath.row==16) {

            [CellTitleLabel setText:@"other zip code"];

        }
        
        else if (indexPath.row==17) {

            [CellTitleLabel setText:@"other country"];

        }
            
        editTextFeild.delegate = self;
        [cell.contentView addSubview:editTextFeild];
        [cell.contentView addSubview:CellTitleLabel];
   
        }
    }
    NSArray *CellArray=cell.contentView.subviews;
    NSLog(@"CellArray %@",CellArray);
    for (UITextField *editTextFeild in CellArray) {
        if ([editTextFeild isKindOfClass:[UITextField class]]) {
            
        
        if (editTextFeild.tag==0) {
            if ( [contactFieldValuesObj.firstName isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.firstName;
            }
            else{
                editTextFeild.placeholder = @"First Name";
                
            }
            
        }
        else if (editTextFeild.tag==1) {
            
            if ( [contactFieldValuesObj.lastName isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.lastName;
            }
            else{
                editTextFeild.placeholder = @"Last Name";
                
            }
            
        }
        else if (editTextFeild.tag==2) {
            if ( [contactFieldValuesObj.accountName isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.accountName;
            }
            else{
                editTextFeild.placeholder = @"account name";
                
            }
            
        }
        
        else if (editTextFeild.tag==3) {
            if ( [contactFieldValuesObj.title isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.title;
            }
            else{
                editTextFeild.placeholder = @"title";
                
            }
            
        }
        
        else if (editTextFeild.tag==4) {
            if ( [contactFieldValuesObj.mailingStreet isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mailingStreet;
            }
            else{
                editTextFeild.placeholder = @"mailing Street";
                
            }
            
        }
        
        else if (editTextFeild.tag==5) {
            if ( [contactFieldValuesObj.mailingCity isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mailingCity;
            }
            else{
                editTextFeild.placeholder = @"mailing City";
                
            }
            
        }
        
        else if (editTextFeild.tag==6) {
            if ( [contactFieldValuesObj.mailingState isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mailingState;
            }
            else{
                editTextFeild.placeholder = @"mailing state";
                
            }
            
        }
        
        else if (editTextFeild.tag==7) {
            if ( [contactFieldValuesObj.mailingZip isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mailingZip;
            }
            else{
                editTextFeild.placeholder = @"mailing zip code";
                
            }
            
        }
        else if (editTextFeild.tag==8) {
            if ([contactFieldValuesObj.mailingCountry isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mailingCountry;
            }
            else{
                editTextFeild.placeholder = @"mailing country";
                
            }
            
        }
        else if  (editTextFeild.tag==9) {
            if ([contactFieldValuesObj.phoneNumber isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.phoneNumber;
            }
            else{
                editTextFeild.placeholder = @"phone number";
                
            }
            
        }
        else if (editTextFeild.tag==10) {
            if ([contactFieldValuesObj.mobileNumber isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.mobileNumber;
            }
            else{
                editTextFeild.placeholder = @"mobile number";
                
            }
            
        }
        else if (editTextFeild.tag==11) {
            if ([contactFieldValuesObj.eMail isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.eMail;
            }
            else{
                editTextFeild.placeholder = @"email";
                
            }
            
        }
        else if (editTextFeild.tag==12) {
            if ([contactFieldValuesObj.dateOfBirth isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.dateOfBirth;
            }
            else{
                editTextFeild.placeholder = @"date of birth";
                
            }
            
        }
        else if (editTextFeild.tag==13) {
            if ([contactFieldValuesObj.otherStreet isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.otherStreet;
            }
            else{
                editTextFeild.placeholder = @"other street";
                
            }
            
        }
        else if (editTextFeild.tag==14) {
            if ([contactFieldValuesObj.otherCity isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.otherCity;
            }
            else{
                editTextFeild.placeholder = @"other city";
                
            }
            
        }
        else if (editTextFeild.tag==15) {
            if ([contactFieldValuesObj.otherState isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.otherState;
            }
            else{
                editTextFeild.placeholder = @"other state";
                
            }
            
        }
        else if (editTextFeild.tag==16) {
            if ([contactFieldValuesObj.otherZip isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.otherZip;
            }
            else{
                editTextFeild.placeholder = @"other zip code";
                
            }
            
        }
        
        else if (indexPath.row==17) {
            if ([contactFieldValuesObj.otherCountry isKindOfClass:[NSString class]] && contactEditFlag==YES) {
                editTextFeild.text=contactFieldValuesObj.otherCountry;
            }
            else{
                editTextFeild.placeholder = @"other country";
                
            }
            
        }
        }
    }
	//if you want to add an image to your cell, here's how
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    DetailViewController *DetailViewControllerObj=[[DetailViewController alloc]init];
    //    [DetailViewControllerObj SetUserID:[[dataRows objectAtIndex:indexPath.row] valueForKey:@"Id"]];
    //    [self.navigationController pushViewController:DetailViewControllerObj animated:YES];
    
}


-(void)deleteContacts:(id)sender{
    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];

    if (APP.offLineMode) {

        NSArray *fields=[[NSArray alloc]initWithObjects:SoupEntryId, nil];
    if (fields) {
        [store removeEntries:fields fromSoup:@"Merchandise" ];
        
        NSDictionary *fieldsDict = [[NSString stringWithFormat:@"{\"Name\":\"%@\"}",UserId] JSONValue];

        [store upsertEntries:[[NSArray alloc]initWithObjects:fieldsDict, nil] toSoup:@"ContactsDeleteQueue"];
        [store removeEntries:[[NSArray alloc]initWithObjects:SoupEntryId, nil] fromSoup:@"Merchandise"];
    }
    
    }
    else{
        SFRestRequest *requestCreate = [[SFRestAPI sharedInstance] requestForDeleteWithObjectType:@"Contact" objectId:UserId];
        
        //send the request
        [[SFRestAPI sharedInstance] send:requestCreate delegate:self];
        [store removeEntries:[[NSArray alloc]initWithObjects:SoupEntryId, nil] fromSoup:@"Merchandise"];

    }
    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark - Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataRows count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSDictionary *obj = [dataRows objectAtIndex:row];

    return [obj objectForKey:@"Name"];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:0]];
    UITextField *valueLbl = (UITextField *)[cell viewWithTag:2];
    NSLog(@"11%@",valueLbl.text);
    
    NSDictionary *obj = [dataRows objectAtIndex:row];

    valueLbl.text=[obj objectForKey:@"Name"];
    contactFieldValuesObj.accountName=[obj objectForKey:@"Name"];
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *value;
    value = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag==0) {
       contactFieldValuesObj.FirstName=value;
        //[FirstName retain];
    }
    else if (textField.tag==1){
        contactFieldValuesObj.LastName=value;
        //[LastName retain];
    }
    else if (textField.tag==2){
        contactFieldValuesObj.accountName=value;
        //[LastName retain];
    }
    else if (textField.tag==3){
        contactFieldValuesObj.title=value;
        //[LastName retain];
    }
    else if (textField.tag==4){
        contactFieldValuesObj.mailingStreet=value;
        //[LastName retain];
    }
    else if (textField.tag==5){
        contactFieldValuesObj.mailingCity=value;
        //[LastName retain];
    }
    else if (textField.tag==6){
        contactFieldValuesObj.mailingState=value;
        //[LastName retain];
    }
    else if (textField.tag==7){
        contactFieldValuesObj.mailingZip=value;
        //[LastName retain];
    }
    else if (textField.tag==8){
        contactFieldValuesObj.mailingCountry=value;
        //[LastName retain];
    }
    else if (textField.tag==9){
        contactFieldValuesObj.phoneNumber=value;
        //[LastName retain];
    }
    else if (textField.tag==10){
        contactFieldValuesObj.mobileNumber=value;
        //[LastName retain];
    }
    else if (textField.tag==11){
        contactFieldValuesObj.eMail=value;
        //[LastName retain];
    }
    else if (textField.tag==12){
        contactFieldValuesObj.dateOfBirth=value;
        //[LastName retain];
    }
    else if (textField.tag==13){
        contactFieldValuesObj.otherStreet=value;
        //[LastName retain];
    }
    else if (textField.tag==14){
        contactFieldValuesObj.otherCity=value;
        //[LastName retain];
    }
    else if (textField.tag==15){
        contactFieldValuesObj.otherState=value;
        //[LastName retain];
    }
    else if (textField.tag==16){
        contactFieldValuesObj.otherZip=value;
        //[LastName retain];
    }
    else if (textField.tag==17){
        contactFieldValuesObj.otherCountry=value;
        //[LastName retain];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGPoint textFieldCenter = textField.center;
    CGPoint pointInTableView = [tableview convertPoint:textFieldCenter fromView:textField.superview];
    if (pointInTableView.y>150) {
        
        [tableview setContentSize:CGSizeMake(320, 1200)];
        [tableview setContentOffset:CGPointMake(0, pointInTableView.y-141) animated:YES];
        
    }
    if (textField.tag==2) {
        textField.inputView=AccountsView;
    }
    else if (textField.tag==12){
        textField.inputView=DateView;
    }
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)SelectAccountsField:(id)sender {
    UIButton *ButtonObj=sender;
    if (ButtonObj.tag==1) {
        
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:0]];
    UITextField *valueLbl = (UITextField *)[cell viewWithTag:2];
    
    [valueLbl resignFirstResponder];
    }
    else{
        
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:1]];
        UITextField *valueLbl = (UITextField *)[cell viewWithTag:12];
        
        [valueLbl resignFirstResponder];


    }
}
- (IBAction)ClearAccountsField:(id)sender {
    
    UIButton *ButtonObj=sender;
    if (ButtonObj.tag==1) {
        
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:0]];
    UITextField *valueLbl = (UITextField *)[cell viewWithTag:2];
    NSLog(@"11%@",valueLbl.text);
    
    
    [valueLbl setText:@""];

        contactFieldValuesObj.accountName=@"";
        
       [valueLbl resignFirstResponder];
    }
    else{
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:1]];
        UITextField *valueLbl = (UITextField *)[cell viewWithTag:12];
        NSLog(@"11%@",valueLbl.text);
        
        
        [valueLbl setText:@""];
        
        contactFieldValuesObj.accountName=@"";
        
        [valueLbl resignFirstResponder];

    }
}

- (IBAction)dateChange:(id)sender {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [outputFormatter stringFromDate:DatePickerView.date];
    
    
    UITableViewCell *cell = [tableview cellForRowAtIndexPath:[CurrentIndexPathArray objectAtIndex:1]];
    UITextField *valueLbl = (UITextField *)[cell viewWithTag:12];
    NSLog(@"11%@",valueLbl.text);
    
    
    [valueLbl setText:dateString];
    
    contactFieldValuesObj.dateOfBirth=dateString;

}

@end
