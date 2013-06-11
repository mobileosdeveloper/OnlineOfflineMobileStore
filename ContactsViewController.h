//
//  ContactsViewController.h
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "LIExposeController.h"
@class Reachability;
@interface ContactsViewController : UIViewController<SFRestDelegate,UITableViewDataSource,UITableViewDelegate,LIExposeControllerChildViewControllerDelegate>
{
    NSMutableArray *dataRows;
    IBOutlet UITableView *tableView;
    Reachability* internetReach;

    UIRefreshControl *refreshControl;

}

@property (nonatomic, retain) NSArray *dataRows;

@end
