/*
 Copyright (c) 2011, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppDelegate.h"
#import "SFNativeRestAppDelegate.h"
#import "SFSmartStore.h"
#import "ContactsViewController.h"
#import "AccountsViewController.h"
#import "ChatterViewController.h"
#import "DetailViewController.h"
#import "Reachability.h"

/*
 NOTE if you ever need to update these, you can obtain them from your Salesforce org,
 (When you are logged in as an org administrator, go to Setup -> Develop -> Remote Access -> New )
 */


// Fill these in when creating a new Remote Access client on Force.com 
static NSString *const RemoteAccessConsumerKey = @"3MVG9Y6d_Btp4xp657x2QyBPkDuA_LurlQvGVuAEg_EV8BJtdTDcX5ZH219z1xzsSgl0wNjzNgXdBSxXKAE4X";
static NSString *const OAuthRedirectURI = @"testsfdc:///mobilesdk/detect/oauth/done";


@implementation AppDelegate
@synthesize offLineMode;

#pragma mark - Remote Access / OAuth configuration


- (NSString*)remoteAccessConsumerKey {
    return RemoteAccessConsumerKey;
}

- (NSString*)oauthRedirectURI {
    return OAuthRedirectURI;
}



#pragma mark - App lifecycle


//NOTE be sure to call all super methods you override.


- (UIViewController*)newRootViewController {
    
    
    
    SFSmartStore *store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    BOOL exists = [store soupExists:@"Merchandise"];
    
    if(!exists) {
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        
        NSMutableDictionary *columnIndex2 = [[NSMutableDictionary alloc] init];
        [columnIndex2 setObject:@"Name" forKey:@"path"];
        [columnIndex2 setObject:@"string" forKey:@"type"];
        
        [store registerSoup:@"Merchandise" withIndexSpecs:[NSArray arrayWithObjects:columnIndex1,columnIndex2, nil]];
        
        [columnIndex1 release];
        [columnIndex2 release];
    }
    exists = [store soupExists:@"Merchandise"];
    
    BOOL existsContactsQueue = [store soupExists:@"ContactsQueue"];
    
    if(!existsContactsQueue) {
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        
        NSMutableDictionary *columnIndex2 = [[NSMutableDictionary alloc] init];
        [columnIndex2 setObject:@"Name" forKey:@"path"];
        [columnIndex2 setObject:@"string" forKey:@"type"];
        
        [store registerSoup:@"ContactsQueue" withIndexSpecs:[NSArray arrayWithObjects:columnIndex1,columnIndex2, nil]];
        
        [columnIndex1 release];
        [columnIndex2 release];
    }
    existsContactsQueue = [store soupExists:@"ContactsQueue"];
    
    //ContactsEditQueue
    BOOL existsContactsEditQueue = [store soupExists:@"ContactsEditQueue"];
    
    if(!existsContactsEditQueue) {
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        
        NSMutableDictionary *columnIndex2 = [[NSMutableDictionary alloc] init];
        [columnIndex2 setObject:@"Name" forKey:@"path"];
        [columnIndex2 setObject:@"string" forKey:@"type"];
        
        [store registerSoup:@"ContactsEditQueue" withIndexSpecs:[NSArray arrayWithObjects:columnIndex1,columnIndex2, nil]];
        
        [columnIndex1 release];
        [columnIndex2 release];
    }
    existsContactsEditQueue = [store soupExists:@"ContactsEditQueue"];

    
    //ContactsDeleteQueue
    
    BOOL existsContactsDeleteQueue = [store soupExists:@"ContactsDeleteQueue"];
    
    if(!existsContactsDeleteQueue) {
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        
        NSMutableDictionary *columnIndex2 = [[NSMutableDictionary alloc] init];
        [columnIndex2 setObject:@"Name" forKey:@"path"];
        [columnIndex2 setObject:@"string" forKey:@"type"];
        
        [store registerSoup:@"ContactsDeleteQueue" withIndexSpecs:[NSArray arrayWithObjects:columnIndex1,columnIndex2, nil]];
        
        [columnIndex1 release];
        [columnIndex2 release];
    }
    existsContactsDeleteQueue = [store soupExists:@"ContactsDeleteQueue"];

    
    
    BOOL existsAcc = [store soupExists:@"AccountSoup"];
    
    if(!existsAcc) {
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        
        NSMutableDictionary *columnIndex2 = [[NSMutableDictionary alloc] init];
        [columnIndex2 setObject:@"Name" forKey:@"path"];
        [columnIndex2 setObject:@"string" forKey:@"type"];
        
        [store registerSoup:@"AccountSoup" withIndexSpecs:[NSArray arrayWithObjects:columnIndex1,columnIndex2, nil]];
        
        [columnIndex1 release];
        [columnIndex2 release];
    }
    existsAcc = [store soupExists:@"AccountSoup"];

    
    
    
   // [store removeEntries:[NSArray arrayWithObject:@"4"] fromSoup:@"Merchandise"];
    

    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability:internetReach];

    
    
    
    LIExposeController *exposeController = [[[LIExposeController alloc] init] autorelease];
    exposeController.exposeDelegate = self;
    exposeController.exposeDataSource = self;
    exposeController.editing = NO ;
    
    exposeController.viewControllers = [NSMutableArray arrayWithObjects:
                                        [self newViewControllerForExposeController:exposeController],
                                        [self newViewControllerForExposeController:exposeController],
                                        nil];


    
    return exposeController;
}


#pragma mark - Helper Methods

- (UIViewController *)newViewControllerForExposeController:(LIExposeController *)exposeController {
    static int TitleCount=0;
    TitleCount++;
    UIViewController *vc;
    if (TitleCount==1) {
        vc = [[[ContactsViewController alloc] init] autorelease];
        vc.title = @"Contacts";

    }
   else if (TitleCount==2) {
       vc = [[[AccountsViewController alloc] init] autorelease];
       vc.title = @"Accounts";
       
    }
   else if (TitleCount==3) {
       vc = [[[ChatterViewController alloc] init] autorelease];
       vc.title = @"Chatter";
       
   }
   else {
       vc = [[[DetailViewController alloc] init] autorelease];
       vc.title = @"Files";
       
   }

        return [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
        

}

#pragma mark - LIExposeControllerDataSource Methods

- (UIView *)backgroundViewForExposeController:(LIExposeController *)exposeController {
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0,
                                                          0,
                                                          exposeController.view.frame.size.width,
                                                          exposeController.view.frame.size.height)] autorelease];
    v.backgroundColor = [UIColor darkGrayColor];
    return v;
}

- (void)shouldAddViewControllerForExposeController:(LIExposeController *)exposeController {
    [exposeController addNewViewController:[self newViewControllerForExposeController:exposeController]
                                  animated:YES];
}

//- (UIView *)addViewForExposeController:(LIExposeController *)exposeController {
//    UIView *addView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:ADD_BUTTON_IMAGE]] autorelease];
//    return addView;
//}

- (UIView *)exposeController:(LIExposeController *)exposeController overlayViewForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [(UINavigationController *)viewController topViewController];
    }
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    viewController.view.bounds.size.width,
                                                                    viewController.view.bounds.size.height)] autorelease];
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        label.text = viewController.title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:22];
//        label.adjustsFontSizeToFitWidth = YES;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        return label;
//    } else {
//        return nil;
//    }
}

- (UILabel *)exposeController:(LIExposeController *)exposeController labelForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = [(UINavigationController *)viewController topViewController];
    }
    if ([viewController isKindOfClass:[LIExposeController class]]) {
        UILabel *label = [[[UILabel alloc] init] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.text = viewController.title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:14];
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(1, 1);
        [label sizeToFit];
        CGRect frame = label.frame;
        frame.origin.y = 4;
        label.frame = frame;
        return label;
    } else {
        return nil;
    }
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
            //[Alert show];
            offLineMode=1;
            break;
        }
            
        case ReachableViaWWAN:
        {
            //            statusString = @"Reachable WWAN";
            //            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Access Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //            [Alert show];
            offLineMode=0;

            break;
        }
        case ReachableViaWiFi:
        {
            statusString= @"Reachable WiFi";
            offLineMode=0;

            break;
        }
    }
    
    
    
}



@end
