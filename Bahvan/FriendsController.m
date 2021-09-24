//
//  FriendsController.m
//  Bahvan
//
//  Created by MacOwner on 12/3/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "FriendsController.h"
//#import "XMPP.h"

@implementation FriendsController
NSMutableArray *FriendsSmpl;

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
//    self. aQ = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(EditClick:)];
    FriendsSmpl = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // rightBarButtonItem
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    
    self.navigationItem.rightBarButtonItem  = item;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self appDelegate].ControllerLoaded = @"FriendsController";
    [FriendsSmpl addObject:@"Mark"];
    //[FriendsSmpl addObject:@"Jennifer"];
    AppDelegate *app = [self appDelegate];
    app.FriendsDelegate = self;
    [[self appDelegate] connect];
    
    //create room
    [[self appDelegate] createRoom];
    /*
    self.str = [[XMPPStream alloc]init];
    [self.str addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.str setHostName:@"54.70.152.41"];
    [self.str setHostPort:5222];
    [self.str setMyJID:[XMPPJID jidWithString:@"mark@bahvan.com"]];
 
    
    NSError *error = nil;
    if (![self.str connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {        
        NSLog(@"Error connecting: %@", error);
    }
*/
}

- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)EditClick:(id)sender {
/*
    [self.myTableView setEditing:!self.myTableView.editing animated: YES];
    [self.editButton setTitle:self.myTableView.editing ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil)];
*/
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [FriendsSmpl count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"mark1.jpg"];
    
    //Button
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(cell.bounds.origin.x + 210, cell.bounds.origin.y + 10, 100, 30);
    [button setTitle:@"Chat" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[button layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    [[button layer] setBorderWidth:1.0f];
    [cell.contentView addSubview:button];
    cell.textLabel.text = [FriendsSmpl objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)FetchFriends
{
    
    NSError *error = [[NSError alloc] init];
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addAttributeWithName:@"id" stringValue:@"ANY_ID_NAME"];
    [iq addAttributeWithName:@"from" stringValue:@"mark@bahvan.com"];
    [iq addChild:query];
    [self.str sendElement:iq];
}

//delegate function
- (void)FriendsListFound:(NSArray *)FriendsList
{
    for (int i=0; i<[FriendsList count]; i++)
    {
        [FriendsSmpl addObject:[[FriendsList[i] attributeForName:@"jid"]stringValue]];
        NSLog(@"Friend: %@",[[FriendsList[i] attributeForName:@"jid"]stringValue]);
    }
    [self.tableView reloadData];

}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    if (queryElement)
    {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        for (int i=0; i<[itemElements count]; i++)
        {
            //[FriendsSmpl addObject:[[itemElements[i] attributeForName:@"jid"]stringValue]];
            NSLog(@"Friend: %@",[[itemElements[i] attributeForName:@"jid"]stringValue]);
        }
        [self.tableView reloadData];
    }
    return NO;
}

- (void)buttonPressed:(id)sender
{
    NSLog(@"Button2pressed!");
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    [self appDelegate].UserMessaged = FriendsSmpl[indexPath.row];
    NSLog(@"%@", [self appDelegate].UserMessaged);

  
    ChatViewController *chatViewController = [[ChatViewController alloc] init];
    chatViewController.hidesBottomBarWhenPushed = YES;
 
    [self.superNavController  pushViewController:chatViewController animated:YES];

}

-(void) addFriend: (id) sender {
    FindFriends *findFriendsController = [[FindFriends alloc] init];
    //findFriendsController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    UINavigationController *navController = [[UINavigationController alloc] init];

 //   [self.superNavController  pushViewController:findFriendsController animated:YES];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    findFriendsController.modalPresentationStyle = UIModalPresentationPopover;
    //[self presentModalViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
    [navController  pushViewController:findFriendsController animated:YES];

}
    
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Unfriend";
}
@end
