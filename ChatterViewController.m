//
//  ChatterViewController.m
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "ChatterViewController.h"
#import "LIExposeController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "SFNativeRestAppDelegate.h"
#import "SFSmartStore.h"
#import "SFSoupQuerySpec.h"
#import "JSON.h"
@interface ChatterViewController ()

@end

@implementation ChatterViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
