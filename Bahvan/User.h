//
//  User.h
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
-(id) initWithID:(NSInteger)ID email:(NSString*)email firstName:(NSString *) firstName lastName:(NSString *)lastName;
@property NSInteger ID;
@property NSString *Email;
@property NSString *Firstname;
@end
