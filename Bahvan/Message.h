//
//  Message.h
//  Bahvan
//
//  Created by MacOwner on 12/13/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
-(id) initWithIncoming:(bool)incoming text:(NSString *)text sentdate:(NSDate *)sentdate;
@property bool Incoming;
@property NSString *Text;
@property NSDate *Sentdate;
@end
