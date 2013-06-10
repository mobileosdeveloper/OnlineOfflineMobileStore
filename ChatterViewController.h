//
//  ChatterViewController.h
//  FindLocations
//
//  Created by ChainSysMac on 06/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIExposeController.h"
#import "SFRestAPI.h"

@interface ChatterViewController : UIViewController<LIExposeControllerChildViewControllerDelegate,SFRestDelegate>

@end
