//
//  User.m
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "User.h"

@implementation User
NSString *lastName;

-(id) initWithID:(NSInteger)ID email:(NSString*)email firstName:(NSString *) firstName lastName:(NSString *)lastName
{
    self = [super init];
    if (self)
    {
        self.ID = ID;
        self.Email = email;
        self.Firstname = firstName;
        //lastName = lastName;
    
    }
    return self;
}
@end
