//
//  Chat.m
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "Chat.h"

@implementation Chat
NSDateFormatter *dateFormatter;

//-(id) initWithUser:(User *)user lastMessageText:(NSString *) lastMessageText lastMessageSentDate:(NSDate*) lastMessageSentDate
//-(id) initWithUser:(User *)user lastMessageText:(NSString *) lastMessageText lastMessageSentDate:(NSDate*) lastMessageSentDate;
-(id) initWithUser:(User2 *)user lastMessageText:(NSString *) lastMessageText lastMessageSentDate:(NSDate*) lastMessageSentDate
{
    self = [super init];
    if (self)
    {
        self.User = user;
        self.Lastmessagetext = lastMessageText;
        self.Lastmessagesentdate = lastMessageSentDate;
        self.LoadedMessages = [[NSMutableArray alloc] init];

    }
    return self;
}

+(NSDateFormatter*) DateFormatter
{
    dateFormatter = [[NSDateFormatter alloc] init];
    return dateFormatter;
}
@end
