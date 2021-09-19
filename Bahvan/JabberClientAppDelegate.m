#import "ChatViewController.h"
#import "JabberClientAppDelegate.h"

@interface JabberClientAppDelegate()

- (void)setupStream;

- (void)goOnline;
- (void)goOffline;

@end


@implementation JabberClientAppDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [self disconnect];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //[self setupStream];
    [self connect];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)setupStream {
    
    self.str = [[XMPPStream alloc] init];
    [self.str addDelegate:self delegateQueue:dispatch_get_main_queue()];

    [self.str setHostName:@"34.219.153.251"];
    [self.str setHostPort:5222];
    [self.str setMyJID:[XMPPJID jidWithString:@"mark@34.219.153.251"]];
    password = @"123";
    
    xmppMessageArchivingStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:self.str];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [self.str sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (void) connect {
    
    [self setupStream];
    /*
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];
    */
    if (![xmppStream isDisconnected]) {
     //   return YES;
    }
    
    /*
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    */
//    NSError *error = nil;
 //   if (![self.str connectWithTimeout:XMPPStreamTimeoutNone error:&error])
 //   {
 /*       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
  */
  //   return NO;
    //}
    
   // return YES;
//
//    self.str = [[XMPPStream alloc]init];
    //self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
//    [self.str addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
//    [self.xmppRoster activate:self.str];
    
//     [self.str setHostName:@"54.70.152.41"];
//     [self.str setHostPort:5222];
//     [self.str setMyJID:[XMPPJID jidWithString:@"mark@bahvan.com"]];
     
     NSError *error = nil;
     if (![self.str connectWithTimeout:XMPPStreamTimeoutNone error:&error])
     {
     
     NSLog(@"Error connecting: %@", error);
     }
    
}

- (void)disconnect {
    
    [self goOffline];
    [xmppStream disconnect];
    [_chatDelegate didDisconnect];
}



#pragma mark -
#pragma mark XMPP delegates


- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    NSLog(@"connected");
    NSError *error = nil;
    if (![self.str authenticateWithPassword:@"D69F7oNEZ" error:&error])
    {
        NSLog(@"Error Authenticating");
    }
    
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    NSLog(@"authenticated");
    
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    
    return NO;
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:msg forKey:@"msg"];
    [m setObject:from forKey:@"sender"];
    
    [_messageDelegate newMessageReceived:m];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSString *presenceType = [presence type]; // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:myUsername]) {
        
        if ([presenceType isEqualToString:@"available"]) {
            
            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"YOURSERVER"]];
            
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            
            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"YOURSERVER"]];
            
        }
        
    }
    
}


- (void)dealloc {
    
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppStream disconnect];
}


@end
