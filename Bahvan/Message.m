//
//  Message.m
//  Bahvan
//
//  Created by MacOwner on 12/13/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "Message.h"

@implementation Message
-(id) initWithIncoming:(bool)incoming text:(NSString *)text sentdate:(NSDate *)sentdate
{
    self = [super init];
    if (self)
    {
        self.Incoming = incoming;
        self.Text = text;
        self.Sentdate = sentdate;
    }
    return self;
}
@end
