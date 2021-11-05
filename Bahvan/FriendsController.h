//
//  FriendsController.h
//  Bahvan
//
//  Created by MacOwner on 12/3/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
#import "AppDelegate.h"
#import "FriendsDelegate.h"
#import "ChatViewController.h"
#import "FindFriends.h"
//#import "SMChatViewController.h"
//#import "SMChatDelegate.h"

@interface FriendsController : UITableViewController<XMPPStreamDelegate, FriendsDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIBarButtonItem *editButton;
@property (nonatomic) NSArray * friendPresence;
@property (strong, nonatomic) XMPPStream *str;
@property (nonatomic, retain) UINavigationController *superNavController;
@end
