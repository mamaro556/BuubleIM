//
//  FriendsDelegate.h
//  Bahvan
//
//  Created by Marvin Amaro on 6/4/19.
//  Copyright © 2019 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FriendsDelegate


 - (void)FriendsListFound:(NSArray *)FriendsList;
- (void)ReceivedPresence:(NSArray*) FriendPresence;

@end
