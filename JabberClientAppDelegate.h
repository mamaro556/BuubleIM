//
//  JabberClientAppDelegate.h
//  JabberClient
//
//  Created by cesarerocchi on 8/3/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPPRoster.h"
#import "XMPP.h"
#import "XMPPStream.h"
#import "ChatDelegate.h"
#import "MessageDelegate.h"

@class ChatViewController;

@interface JabberClientAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ChatViewController *viewController;
    
    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;

    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    
    NSString *password;
    
    BOOL isOpen;
    
    __weak NSObject <ChatDelegate> *_chatDelegate;
    __weak NSObject <MessageDelegate> *_messageDelegate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ChatViewController *viewController;

@property (strong, nonatomic) XMPPStream *str;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;

@property (nonatomic, assign) id  _chatDelegate;
@property (nonatomic, assign) id  _messageDelegate;

- (void) connect;
- (void) disconnect;

@end

