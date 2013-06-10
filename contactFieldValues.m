//
//  contactFieldValues.m
//  FindLocations
//
//  Created by ChainSysMac on 07/06/13.
//  Copyright (c) 2013 Chain-Sys. All rights reserved.
//

#import "contactFieldValues.h"

@implementation contactFieldValues
@synthesize firstName;
@synthesize lastName;
@synthesize accountName;
@synthesize title;
@synthesize mailingStreet;
@synthesize mailingCity;
@synthesize mailingState;
@synthesize mailingZip;
@synthesize mailingCountry;
@synthesize phoneNumber;
@synthesize mobileNumber;
@synthesize eMail;
@synthesize dateOfBirth;
@synthesize otherStreet;
@synthesize otherCity;
@synthesize otherState;
@synthesize otherZip;
@synthesize otherCountry;

-(id)init
{
   self.firstName= [[NSString alloc] init];
   self.lastName= [[NSString alloc] init];
   self.accountName= [[NSString alloc] init];
   self.title= [[NSString alloc] init];
   self.mailingStreet= [[NSString alloc] init];
   self.mailingCity= [[NSString alloc] init];
   self.mailingState= [[NSString alloc] init];
   self.mailingZip= [[NSString alloc] init];
   self.mailingCountry= [[NSString alloc] init];
   self.phoneNumber= [[NSString alloc] init];
   self.mobileNumber= [[NSString alloc] init];
   self.eMail= [[NSString alloc] init];
   self.dateOfBirth= [[NSString alloc] init];
   self.otherStreet= [[NSString alloc] init];
   self.otherCity= [[NSString alloc] init];
   self.otherState= [[NSString alloc] init];
   self.otherZip= [[NSString alloc] init];
   self.otherCountry= [[NSString alloc] init];
    
   return self;
}

@end
