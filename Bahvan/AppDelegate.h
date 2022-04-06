//
//  AppDelegate.h
//  Bahvan
//
//  Created by MacOwner on 11/29/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//
// import "XMPPRoster.h"
#import "XMPP.h"
#import "XMPPStream.h"
#import <UIKit/UIKit.h>
#import "Account.h"
#import "FriendsDelegate.h"
#import "MessageDelegate.h"
#import "FriendsController.h"
#import "XMPPRoomMemoryStorage.h"
//#import "XEP-0136/CoreDataStorage/XMPPMessageArchivingCoreDataStorage.h"
//#import "XEP-0136/XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"


@protocol FriendsDelegate;
@protocol MessageDelegate;
@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPStreamDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) NSString *jidstring;
@property (strong, nonatomic) NSString *passwordstring;
@property (nonatomic, retain) UINavigationController *navController2;
@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (strong, nonatomic) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (nonatomic, assign) id <FriendsDelegate> FriendsDelegate;
@property (nonatomic, assign) id <MessageDelegate> MessageDelegate;
@property NSString *ControllerLoaded;
@property NSString *UserMessaged;
- (void) connect;
- (void) createRoom;
+(void)initialize;
@end

