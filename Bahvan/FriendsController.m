//
//  FriendsController.m
//  Whatoji
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
    
    AppDelegate *del = [self appDelegate];
    del.ControllerLoaded = @"FriendsController";
    del.FriendsDelegate = self;
    [del connect];
    
    //create room
    //[[self appDelegate] createRoom];
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
    if ([FriendsSmpl containsObject:self.friendPresence[1]]&&[self.friendPresence[0] isEqualToString:@"available"]) {
        for (int i = 0; i< FriendsSmpl.count; i++) {
            if ([[FriendsSmpl objectAtIndex:indexPath.row]  isEqualToString:self.friendPresence[1]]) {
                cell.imageView.image = [UIImage imageNamed:@"greenstatus.png"];
            }
            else {
                cell.imageView.image = [UIImage imageNamed:@"redstatus.png"];
            }
        }
        
        
    }

    // resize imageView
    CGSize itemSize = CGSizeMake(32, 32);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
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
- (void)FriendsListFound:(NSArray *)FriendsList {
    for (int i=0; i<[FriendsList count]; i++) {
        [FriendsSmpl addObject:[[FriendsList[i] attributeForName:@"jid"]stringValue]];
        NSLog(@"Friend: %@",[[FriendsList[i] attributeForName:@"jid"]stringValue]);
        
        NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
        [presence addAttributeWithName:@"to" stringValue:[[FriendsList[i] attributeForName:@"jid"]stringValue]];
        [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
        [[self appDelegate].xmppStream sendElement:presence];
    }
    [self.tableView reloadData];
}

//delegate function
- (void) ReceivedPresence: (NSArray *) FriendPresence {
    
    self.friendPresence = FriendPresence;
    NSLog(@"%@", FriendPresence);

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
