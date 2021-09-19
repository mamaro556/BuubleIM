//
//  Account.m
//  Bahvan
//
//  Created by MacOwner on 12/15/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "Account.h"
#import "AppDelegate.h"
#import "Chat.h"
#import "User2.h"
#import "Message.h"
#import <CoreData/CoreData.h>
#import "XMPPMessageArchivingCoreDataStorage.h"
@implementation Account

- (id)init
{
    if( self = [super init] )
    {
        // Initialize your object here
        self.chats = [[NSMutableArray alloc] init];
        
        [self.chats addObject: [[Chat alloc ]initWithUser:[[User2 alloc ]initWithJID:@"Matt"] lastMessageText:@"Thanks for checking out Chats! :-)"  lastMessageSentDate:[NSDate date]] ];
        [self.chats addObject: [[Chat alloc ]initWithUser:[[User2 alloc ]initWithJID:@"Angel"] lastMessageText:@"6 sounds good :-)"  lastMessageSentDate:[[NSDate date] dateByAddingTimeInterval:-5]]];

        
        
        // sample data
 //       [self.chats addObject: [[Chat alloc ]initWithUser:[[User alloc ]initWithID:1 email:@"mattdipasquale@nec.com" firstName:@"Matt"  lastName:@"Di Pasquale"] lastMessageText:@"Thanks for checking out Chats! :-)"  lastMessageSentDate:[NSDate date]] ];
 //       [self.chats addObject: [[Chat alloc ]initWithUser:[[User alloc ]initWithID:2 email:@"samihah@nas.gov" firstName:@"Angel"  lastName:@"Rao"] lastMessageText:@"6 sounds good :-)"  lastMessageSentDate:[[NSDate date] dateByAddingTimeInterval:-5]]];
        

        //Chat *chat = (Chat *)self.chats[1];
        
        //Add 2 Messages
/*
        NSMutableArray *ArrMsg1 = [NSMutableArray arrayWithObjects:[[Message alloc] initWithIncoming:true text:@"I really enjoyed programming with you! :-)" sentdate:[[NSDate date] dateByAddingTimeInterval:-60*60*24*2-60*60]], [[Message alloc] initWithIncoming:false text:@"Thanks! Me too! :-)" sentdate:[[NSDate date] dateByAddingTimeInterval:-60*60*24*2]], nil];
        
        [((Chat *)self.chats[1]).LoadedMessages addObject:ArrMsg1];
        
        NSMutableArray *ArrMsg2 = [NSMutableArray arrayWithObjects:[[Message alloc] initWithIncoming:true text:@"Hey, would you like to spend some time together tonight and work on Acani?" sentdate:[[NSDate date] dateByAddingTimeInterval:-33]], [[Message alloc] initWithIncoming:false text:@"Sure, I'd love to. How's 6 PM?" sentdate:[[NSDate date] dateByAddingTimeInterval:-19]], nil];
        
        [((Chat *)self.chats[1]).LoadedMessages addObject:ArrMsg2];
*/
        
        /*
        [((Chat *)self.chats[1]).LoadedMessages addObject:[[Message alloc] initWithIncoming:true text:@"I really enjoyed programming with you! :-)" sentdate:[[NSDate date] dateByAddingTimeInterval:-60*60*24*2-60*60]]];
        
        [((Chat *)self.chats[1]).LoadedMessages addObject:[[Message alloc] initWithIncoming:false text:@"Thanks! Me too! :-)" sentdate:[[NSDate date] dateByAddingTimeInterval:-60*60*24*2]]];

        [((Chat *)self.chats[1]).LoadedMessages addObject:[[Message alloc] initWithIncoming:true text:@"Hey, would you like to spend some time together tonight and work on Acani?" sentdate:[[NSDate date] dateByAddingTimeInterval:-33]]];
        
        [((Chat *)self.chats[1]).LoadedMessages addObject:[[Message alloc] initWithIncoming:false text:@"Sure, I'd love to. How's 6 PM?" sentdate:[[NSDate date] dateByAddingTimeInterval:-19]]];
*/

    }
    
    return self;
}

-(void) print:(NSMutableArray*)messages{
    @autoreleasepool {
        for(XMPPMessageArchiving_Message_CoreDataObject *message in messages)
        {
            NSLog(@"messageStr param is %@", message.messageStr);
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            NSLog(@"NSCore object id param is %@",message.objectID);
            NSLog(@"bareJid param is %@",message.bareJid);
            NSLog(@"bareJidStr param is %@",message.bareJidStr);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.timestamp);
            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
            
        }
    }
}

- (AppDelegate *) appDelegate {
        return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
