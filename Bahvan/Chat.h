//
//  Chat.h
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User2.h"

@interface Chat : NSObject

-(id) initWithUser:(User2 *)user lastMessageText:(NSString *) lastMessageText lastMessageSentDate:(NSDate*) lastMessageSentDate;



+(NSDateFormatter*) DateFormatter;

@property User2 *User;
@property NSMutableArray *LoadedMessages;
@property NSString *Lastmessagetext;
@property NSDate *Lastmessagesentdate;
@property NSString *Draft;

@end
