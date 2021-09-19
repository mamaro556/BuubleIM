//
//  ChatViewController.h
//  Bahvan
//
//  Created by Marvin Amaro on 6/4/19.
//  Copyright © 2019 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
#import "AppDelegate.h"
#import "FriendsDelegate.h"
#import "MessageDelegate.h"
//#import "SMChatViewController.h"
//#import "SMChatDelegate.h"

@interface ChatViewController : UIViewController<XMPPStreamDelegate, FriendsDelegate, MessageDelegate>
@property NSMutableArray *chats;
@property (strong, nonatomic) UIToolbar *Toolbar;
@property (strong, nonatomic) XMPPStream *str;
@property (strong, nonatomic) UITextView *Textview;
@property (strong, nonatomic) UIButton *Send;
@property (strong, nonatomic) UITableView *ChatView;
@property (nonatomic) CGRect KeyboardFrame;
@property (strong, nonatomic) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (strong, nonatomic) XMPPRoster *xmppRoster;
@property (nonatomic) CGFloat insetChange;
@property (nonatomic) CGFloat oldContentOffset;
@end
