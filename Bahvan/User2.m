//
//  User2.m
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "User2.h"

@implementation User2

-(id) initWithJID:(NSString*)JID{
    self = [super init];
    if (self)
    {
        self.JID = JID;
    }
    return self;
}
@end
