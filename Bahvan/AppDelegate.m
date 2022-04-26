//
//  AppDelegate.m
//  Bahvan
//
//  Created by MacOwner on 11/29/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "AppDelegate.h"
#import "Bahvan-Swift.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [FBSDKAppEvents activateApp];
    NSLog(@"applicationWillResignActive");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.    
    NSLog(@"applicationWillResignActive");
    //[self disconnect];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    
    LoginController *loginController = [[LoginController alloc] init];
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];
   
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    return YES;
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    BOOL handled = [[FBSDKApplicatioanDelegate sharedInstance] application:application
//                                                                  openURL:url
//                                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
//                    ];
    // Add any custom logic here.
    //return handled;
    return YES;
}

- (void)LoadHomeControllers {

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    NSMutableArray *navControllerArray = [[NSMutableArray alloc] initWithCapacity:2];
    UIViewController *home = [[UIViewController alloc] init];
    FriendsController *friendsController = [[FriendsController alloc] init];
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:home];
   
    UIImage *image1 = [UIImage imageNamed:@"first"];
    navController1.tabBarItem.selectedImage = image1;
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:friendsController];
    friendsController.superNavController = navController2;
    UIImage *image2 = [UIImage imageNamed:@"second"];
    navController2.tabBarItem.image =image2;
    
    [navControllerArray addObject:navController1];
    [navControllerArray addObject:navController2];
    tabBarController.viewControllers = navControllerArray;
    tabBarController.selectedIndex = 1  ;
    tabBarController.tabBar.items[0].image = image1;
    tabBarController.tabBar.items[1].image = image2;

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

/* swift ver
 let app: AppDelegate = appDelegate()

 window = UIWindow(frame: UIScreen.main.bounds)

 var tabBarController:UITabBarController = UITabBarController()
 var navControllerArray:NSMutableArray = NSMutableArray(capacity: 2)
 var home:UIViewController = UIViewController()
 var friendsController:FriendsController  = FriendsController()
 var navController1:UINavigationController = UINavigationController(rootViewController: home)

 let image1:UIImage = UIImage(named: "first")!
 navController1.tabBarItem.selectedImage = image1;
 var navController2:UINavigationController = UINavigationController(rootViewController: friendsController)
 friendsController.superNavController = navController2
 let image2:UIImage = UIImage(named: "second")!
 navController2.tabBarItem.image = image2;
 
 //navControllerArray.addObjects(from: navController1)
 //[navControllerArray addObject:navController2];
 tabBarController.viewControllers = [navController1, navController2]
 tabBarController.selectedIndex = 1
 tabBarController.tabBar.items?[0].image = image1;
 tabBarController.tabBar.items?[1].image = image2;
 

 window?.rootViewController = tabBarController
 app.window?.makeKeyAndVisible()
 */

}

- (void)setupStream {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *hostname = settings[@"HostName"];
    NSString *portstring = settings[@"HostPort"];
    NSInteger port = [portstring integerValue];
    
    [self.xmppStream setHostName:hostname];
    [self.xmppStream setHostPort:port];
    [self.xmppStream setMyJID:[XMPPJID jidWithString:self.jidstring]];
}


-(void) createRoom {
    XMPPRoomMemoryStorage *roomStorage = [[XMPPRoomMemoryStorage alloc] init];
    
    /**
     * Remember to add 'conference' in your JID like this:
     * e.g. uniqueRoomJID@conference.yourserverdomain
     */
    
    XMPPJID *roomJID = [XMPPJID jidWithString:@"fam@bahvan.com"];
    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomStorage
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:self.xmppStream];
    [xmppRoom addDelegate:self
            delegateQueue:dispatch_get_main_queue()];
    
    [xmppRoom joinRoomUsingNickname:self.xmppStream.myJID.user
                            history:nil
                           password:nil];
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender {
    NSLog(@"Room did create.");
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender {
    NSLog(@"Room did join");
    [sender fetchConfigurationForm];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm {
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    
    for (NSXMLElement *field in fields) {
        NSString *var = [field attributeStringValueForName:@"var"];
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
    }
    
    [sender configureRoomUsingOptions:newConfig];
}

- (void) connect {
    
    NSError *error = nil;
    //self.jidstring = user;
    /*if ([self.xmppStream isConnected]) {
        
        if (![self.xmppStream isAuthenticated]) {
            if (![self.xmppStream authenticateWithPassword:@"123" error:&error]) {
                NSLog(@"Error Authenticating");
            }
        }
        NSLog(@"here");
    }
    else {
    */
    [self setupStream];
        
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {

        NSLog(@"Error connecting: %@", error);
    }
    
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
         
         NSLog(@"connected");
         NSError *error = nil;
         if (![self.xmppStream authenticateWithPassword:self.passwordstring error:&error]) {
             NSLog(@"Error Authenticating");
         }
         
}
    
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
         
    NSLog(@"authenticated");
    self.xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    self.xmppMessageArchivingModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.xmppMessageArchivingCoreDataStorage];
    self.xmppMessageArchivingModule.clientSideMessageArchivingOnly = YES;
    [self.xmppMessageArchivingModule activate:self.xmppStream];
    [self.xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.account = [[Account alloc] init];

    XMPPPresence *presence = [XMPPPresence presence];

 /*   if ([self.ControllerLoaded  isEqual: @"FriendsController"]) {
        [self.xmppStream sendElement:presence];
        [self FetchFriends];
    }
 */

    [self.xmppStream sendElement:presence];
    [self FetchFriends];
    
}

- (void)LoadControllers {
    
    
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    DDXMLElement *errorXML = [error elementForName:@"error"];
    NSString *errorCode = [[errorXML attributeForName:@"code"] stringValue];
    
    NSString *regError = [NSString stringWithFormat:@"ERROR :- %@",error.description];
}



- (void)FetchFriends {
    NSError *error = [[NSError alloc] init];
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:@"ID_NAME"];
    [iq addAttributeWithName:@"from" stringValue:@"mark@localhost"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    if (queryElement) {
        NSLog(@"This is query element: %@", queryElement);
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        [self.FriendsDelegate FriendsListFound:itemElements];
    }
    return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(nonnull XMPPPresence *)presence {
    NSString* type;
    NSString* from;
    XMPPJID* pf;
    
    type = [presence type];
    from = [[presence from] bare];
    NSArray* friendPresence;
    friendPresence = @[type, from];
    [self.FriendsDelegate ReceivedPresence:friendPresence];
}
    
- (void) xmppStream:(XMPPStream *)sender didReceiveMessage:(nonnull XMPPMessage *)message {
    NSLog(@"This is message: %@", message);
    NSString *msg = [[message elementForName:@"body"]stringValue];
    NSString *from = [[message attributeForName:@"from"]stringValue];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:msg forKey:@"msg"];
    [dic setObject:from forKey:@"sender"];
    
    [self.MessageDelegate newMessageReceived:dic];
}


- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    NSLog(@"did not authenticate");
}


- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    NSLog(@"StreamDidDisconnect");
    NSLog(@"This is error: %@",error);
    NSLog(@"StreamDidDisconnectEnd");
}

/*
+(void)initialize
{
    if (self == [AppDelegate class])
    {
        self->account = [[Account alloc] init];
    }
}
*/

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
