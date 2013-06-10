//
//  AddEditViewController.h
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "Reachability.h"
#import "contactFieldValues.h"

@interface AddEditViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SFRestDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UITableView *tableview;
    Reachability* internetReach;
    contactFieldValues *contactFieldValuesObj;
    IBOutlet UIView *AccountsView;
    IBOutlet UIPickerView *AccountsPickerView;
    IBOutlet UIView *DateView;
    IBOutlet UIDatePicker *DatePickerView;

    NSMutableArray *CurrentIndexPathArray;
    
    BOOL contactEditFlag;
    NSString *UserId;
    NSString *SoupEntryId;

}
@property(nonatomic,retain)NSString *FirstName;
@property(nonatomic,retain)NSString *LastName;
@property(nonatomic,retain) contactFieldValues *contactFieldValuesObj;
@property (nonatomic, retain) NSArray *dataRows;
@property (nonatomic, retain)IBOutlet UITableView *tableview;

@property (nonatomic, retain)IBOutlet UIView *AccountsView;
@property (nonatomic, retain)IBOutlet UIPickerView *AccountsPickerView;
@property (nonatomic, retain)IBOutlet UIView *DateView;
@property (nonatomic, retain)IBOutlet UIDatePicker *DatePickerView;

- (IBAction)SelectAccountsField:(id)sender;
- (IBAction)ClearAccountsField:(id)sender;
- (IBAction)dateChange:(id)sender;
-(void)ContactViewState:(BOOL)ContactEditFlagObj UserID:(NSString *)UserIdObj SoupEntryId:(NSString *)SoupEntryIdObj;

@end
