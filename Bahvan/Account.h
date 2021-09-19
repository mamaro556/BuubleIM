//
//  Account.h
//  Bahvan
//
//  Created by MacOwner on 12/15/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property NSMutableArray *chats;
//        NSFetchRequest *fetchRequest;
-(void) print:(NSMutableArray*) messages;
@end
