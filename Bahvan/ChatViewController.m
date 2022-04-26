//
//  ChatViewController.m
//  Bahvan
//
//  Created by MacOwner on 12/12/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//
//#import  <Bahvan/Bahvan-Swift.h>
#import "Bahvan-Swift.h"
#import "ChatViewController.h"
#import "Chat.h"
#import "User2.h"
#import <CoreData/CoreData.h>
#import "XMPPMessageArchivingCoreDataStorage.h"

//#import "User.h"
#import "Message.h"
#import "MessageSentDateTableViewCell.h"
#import "MessageBubbleTableViewCell.h"

#import "AppDelegate.h"


static CGFloat chatMessageFontSize = 17.0;
static NSInteger iChatRow = 0;
CGFloat toolBarMinHeight = 44;
CGFloat textViewMaxHeight = 272;

Chat *C;

bool rotating = false;
Product *products[1];  // array of Product

@implementation ChatViewController  

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self getMessageHistory];
    }
    return self;
}

+(CGFloat) GetChatMessageFontSize
{
    return chatMessageFontSize;
}

-(UIView *) inputAccessoryView
{
    if (self.Toolbar == nil)
    {
        self.Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, toolBarMinHeight-0.5)];

        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        
        
        // image view setup
        [imageView setImage:[UIImage imageNamed:@"image"]];
        //[self.Toolbar addSubview:imageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        
        tapGesture.numberOfTapsRequired = 1;
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:tapGesture];
        [self.Toolbar addSubview:imageView];
        
        self.Textview = [[UITextView alloc]initWithFrame: CGRectZero];
        self.Textview.backgroundColor = [UIColor colorWithWhite:250.0/255 alpha:1.0];
        self.Textview.delegate = self;
        self.Textview.font = [UIFont systemFontOfSize:chatMessageFontSize];
        //self.Textview.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
        [[self.Textview layer] setBorderColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue: 205.0/255 alpha:1.0].CGColor];
        [[self.Textview layer] setBorderWidth:0.5f];
        self.Textview.layer.cornerRadius = 5.0f;
        self.Textview.scrollsToTop = NO;
        self.Textview.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3);
        self.Textview.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.Toolbar addSubview:self.Textview];
        
        self.Send = [UIButton buttonWithType:UIButtonTypeSystem];
        self.Send.enabled = NO;
        self.Send.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.Send setTitle:@"Send" forState:UIControlStateNormal];
        [self.Send setTitleColor:[UIColor colorWithRed: 142.0/255 green: 142.0/255 blue: 147.0/255 alpha: 1.0]  forState: UIControlStateDisabled];
        [self.Send setTitleColor:[UIColor colorWithRed: 1.0/255 green: 122.0/255 blue: 255.0/255 alpha: 1.0]  forState: UIControlStateNormal];
        self.Send.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
        [self.Send addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.Toolbar addSubview:self.Send];
        
        // Auto Layout allows `sendButton` to change width, e.g., for localization.
        self.Textview.translatesAutoresizingMaskIntoConstraints = NO;
        self.Send.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        
    
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem: self.Toolbar attribute:NSLayoutAttributeLeading multiplier:1  constant:8 ]];

        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Textview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem: imageView attribute:NSLayoutAttributeTrailing multiplier:1  constant:8 ]];

        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem: self.Toolbar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
 /*
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem: self.Textview attribute:NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.Toolbar attribute:NSLayoutAttributeLeading multiplier: 1 constant: 8]];
*/
  /*
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem: self.Textview attribute:NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: imageView attribute:NSLayoutAttributeTrailing multiplier: 1 constant: 8]];
 */
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Textview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self.Toolbar attribute:NSLayoutAttributeTop multiplier: 1 constant: 7.5]];
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Textview attribute: NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem: self.Send attribute: NSLayoutAttributeLeading multiplier: 1 constant: -2]];
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Textview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem: self.Toolbar attribute:NSLayoutAttributeBottom multiplier: 1 constant: -8]];
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Send attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationGreaterThanOrEqual toItem: self.Toolbar attribute:NSLayoutAttributeTrailing multiplier: 1 constant: 0]];
        [self.Toolbar addConstraint:[NSLayoutConstraint constraintWithItem:self.Send attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem: self.Toolbar attribute:NSLayoutAttributeBottom  multiplier: 1 constant: -4.5]];

    }
    return self.Toolbar;
}

-(void) getMessageHistory {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).account.chats removeObjectAtIndex:1];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).account.chats insertObject: [[Chat alloc ]initWithUser:[[User2 alloc ]initWithJID:@"Angel"] lastMessageText:@"6 sounds good :-)"  lastMessageSentDate:[[NSDate date] dateByAddingTimeInterval:-5]] atIndex:1];
    C = ((AppDelegate *)[UIApplication sharedApplication].delegate).account.chats[1];
    //self.title =  C.User.JID;
    self.title = [self appDelegate].UserMessaged;
    self.hidesBottomBarWhenPushed = YES;

    //This is Message history store in core data
    
    //  NSString *userJID = [NSString stringWithFormat:@"%@@%@", userName, self.hostName];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext  *context = [[self appDelegate].xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *messageEntity = [NSEntityDescription  entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    
    fetchRequest.entity = messageEntity;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    NSString *predicateFrmt = @"bareJidStr == %@";
    NSString *userMessaged;
    userMessaged = [self appDelegate].UserMessaged;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, userMessaged];
    fetchRequest.predicate = predicate;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    NSDateFormatter *dateFormatter = [Chat DateFormatter];
    NSDate *date;
    NSMutableArray *ArrMsg;
    int intOutgoing;
    bool boolOutgoing;
    
    
    //      for (int i=0; i<[results count]; i++)
    //       {
    //           NSLog(@"Chat: %@",[[results[i] attributeForName:@"jid"]stringValue]);c\
    //       }
    NSLog(@"Chat: %@", [NSString stringWithFormat:@"%lu", (unsigned long)[results count]]);
    //        [self print:[[NSMutableArray alloc] initWithArray:results]];
    @autoreleasepool {
        for(int i = (int)[results count] - 1; i > -1; i--)
        {
            XMPPMessageArchiving_Message_CoreDataObject *message = [results objectAtIndex:i];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            date = message.timestamp;
            intOutgoing = [message.outgoing intValue];
            if (intOutgoing == 0)
            {
                boolOutgoing = false;
            }
            else
            {
                boolOutgoing = true;
            }
            ArrMsg = [NSMutableArray arrayWithObjects:[[Message alloc] initWithIncoming:!boolOutgoing text:message.body sentdate:date], nil];
//                [((Chat *)self.chats[1]).LoadedMessages addObject:ArrMsg];
            [C.LoadedMessages addObject:ArrMsg];
            NSLog(@"xmpp to: %@", message.message.toStr);
            NSLog(@"xmpp from: %@", message.message.fromStr);
            NSLog(@"xmpp stringvalue: %@", message.message.stringValue);
            NSLog(@"xmpp XMLstring: %@", message.message.XMLString);
            NSLog(@"messageStr param is %@", message.messageStr);
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            NSLog(@"NSCore object id param is %@",message.objectID);
            NSLog(@"bareJid param is %@",message.bareJid);
            NSLog(@"bareJidStr param is %@",message.bareJidStr);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.timestamp);
            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
                
        }
    }
}


-(void) tapDetected{
    
    NSLog(@"tap detected on imageview");
    UIView *    stickerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    stickerView.frame = self.KeyboardFrame;
    stickerView.backgroundColor = [UIColor redColor];
    stickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stickerView];
    
    //Setup Constraints
    [self.view addConstraint:[NSLayoutConstraint
        constraintWithItem:stickerView
        attribute:NSLayoutAttributeTop
        relatedBy:NSLayoutRelationEqual toItem: self.view
        attribute:NSLayoutAttributeTop multiplier:1  constant:self.KeyboardFrame.origin.y ]];
 
    [self.view addConstraint:[NSLayoutConstraint
        constraintWithItem:stickerView
        attribute:NSLayoutAttributeBottom
        relatedBy:NSLayoutRelationEqual toItem: self.view
        attribute:NSLayoutAttributeBottom multiplier:1  constant:0 ]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem: self.view attribute:NSLayoutAttributeLeading multiplier:1  constant:0 ]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stickerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem: self.view attribute:NSLayoutAttributeTrailing multiplier:1  constant:0 ]];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - UIResponder


- (BOOL) canBecomeFirstResponder
{
    return YES;
}


// MARK: - UIViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    CGFloat TopBarsHeight;
    CGFloat StbarHeight;
    StbarHeight = 20;
    
    [self createProductArray];
    
     self.hidesBottomBarWhenPushed = YES;
    AppDelegate *app = [self appDelegate];
    app.MessageDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];// smooths push animation
    TopBarsHeight = self.navigationController.navigationBar.frame.size.height + StbarHeight;
    self.ChatView = [[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStylePlain];
    self.ChatView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UIEdgeInsets Insets = UIEdgeInsetsMake(TopBarsHeight, 0, 0, 0);
    self.ChatView.contentInset = Insets;
    self.ChatView.dataSource = self;
    self.ChatView.delegate = self;
    self.ChatView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.ChatView.estimatedRowHeight = 44;
    self.ChatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.ChatView.scrollEnabled = YES;
    [self appDelegate].ControllerLoaded = @"ChatViewController";
    
//    self.str = [[XMPPStream alloc]init];
    self.xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
   // [self.str addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterStorage];
 //   [self.xmppRoster activate:self.str];

    [self.ChatView registerClass:MessageSentDateTableViewCell.self forCellReuseIdentifier:@"SentDateCell"];
    [self.view addSubview:self.ChatView];
    self.ChatView.translatesAutoresizingMaskIntoConstraints = NO;
    
 //   JabberClientAppDelegate *del = [self appDelegate];
    //del._chatDelegate = self;


    /*
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint
                                      constraintWithItem: self.ChatView
                                      attribute: NSLayoutAttributeLeading
                                      relatedBy: NSLayoutRelationEqual
                                      toItem: self.view
                                      attribute: NSLayoutAttributeLeading
                                      multiplier:1.0
                                      constant:0];
    [self.view addConstraint:constraint];
    self.CVConst = [NSLayoutConstraint
                            constraintWithItem: self.ChatView
                            attribute: NSLayoutAttributeBottom
                            relatedBy: NSLayoutRelationEqual
                            toItem: self.view
                            attribute: NSLayoutAttributeBottom
                            multiplier:1.0
                            constant:0];
    
     [self.view addConstraint:self.self.CVConst];

    constraint = [NSLayoutConstraint
                  constraintWithItem: self.ChatView
                  attribute: NSLayoutAttributeTrailing
                  relatedBy: NSLayoutRelationEqual
                  toItem: self.view
                  attribute: NSLayoutAttributeTrailing
                  multiplier:1.0
                  constant:0];
    [self.view addConstraint:constraint];
    
    self.CVHeight = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height;
    constraint = [NSLayoutConstraint
                  constraintWithItem: self.ChatView
                  attribute: NSLayoutAttributeHeight
                  relatedBy: NSLayoutRelationEqual
                  toItem: nil
                  attribute: NSLayoutAttributeNotAnAttribute
                  multiplier:1.0
                  constant:self.CVHeight];
    [self.ChatView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint
                  constraintWithItem: self.ChatView
                  attribute: NSLayoutAttributeWidth
                  relatedBy: NSLayoutRelationEqual
                  toItem: nil
                  attribute: NSLayoutAttributeNotAnAttribute
                  multiplier:1.0
                  constant:self.view.frame.size.width];
    [self.ChatView addConstraint:constraint];
*/


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
// notificationCenter.addObserver(self, selector: #selector(ChatViewController.menuControllerWillHide(_:)), name: UIMenuControllerWillHideMenuNotification, object: nil)
  
    // #CopyMessage
 
 // tableViewScrollToBottomAnimated(false) // doesn't work
 }


- (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

 - (XMPPStream *) xmppStream {
    return [self appDelegate].xmppStream;
}
/*
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    NSLog(@"some security thing");
    if (self.allowSelfSignedCertificates)
    {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString  *)kCFStreamSSLValidatesCertificateChain];
    }
    if (self.allowSSLHostNameMismatch)
    {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
    else
    {
*/        // Google does things incorrectly (does not conform to RFC).
        // Because so many people ask questions about this (assume xmpp framework is broken),
        // I've explicitly added code that shows how other xmpp clients "do the right thing"
        // when connecting to a google server (gmail, or google apps for domains).
/*        NSString *expectedCertName = nil;
        NSString *serverDomain = self.str.hostName;
       NSString *virtualDomain = [self.str.myJID domain];
        if ([serverDomain isEqualToString:@"talk.google.com"])
        {
            if ([virtualDomain isEqualToString:@"gmail.com"])
            {
                expectedCertName = virtualDomain;
            }
            else
            {
                expectedCertName = serverDomain;
            }
        }
        else if (serverDomain == nil)
        {
            expectedCertName = virtualDomain;
        }
        else
        {
            expectedCertName = serverDomain;
        }
        if (expectedCertName)
        {
            [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
        }
    }
}
*/

/*
- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    [self.str sendElement:presence];
}
*/



-(void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    NSLog(@"enterintviewDidAppear");
    NSLog(@"%@", [self appDelegate].ControllerLoaded);

    [[self appDelegate] connect];
    [self.ChatView flashScrollIndicators];
 }
    
-(void) viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    C.Draft = self.Textview.text;
 }

// This gets called a lot. Perhaps there's a better way to know when `view.window` has been set?

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
    if (C.Draft != 0) {
     self.Textview.text = C.Draft;
     C.Draft = @"";
     //textViewDidChange(textView)
        [self.Textview becomeFirstResponder];
    }
 }

// MARK: - UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView{
    return C.LoadedMessages.count;
}

-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray*)C.LoadedMessages[section]).count + 1; // for sent-date cell
}

-(UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if(indexPath.row == 0)
    {
        MessageSentDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SentDateCell" forIndexPath: indexPath];
        Message *message = C.LoadedMessages[indexPath.section][0];
        NSDateFormatter *formatter = [Chat DateFormatter];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        cell.sentDateLabel.text = [formatter stringFromDate:message.Sentdate];
        return cell;
    }
    else
    {
/*        if (indexPath.section == 3) {
            NSString *cellIdentifier = @"EcommerceCell";
               ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[ProductCell alloc] initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier];
                }
                
 /*
                // Add gesture recognizers #CopyMessage
    /*
                let action: Selector = #selector(ChatViewController.messageShowMenuAction(_:))
                let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
                doubleTapGestureRecognizer.numberOfTapsRequired = 2
                cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
                cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
     */
            //}
            //Message *message = C.LoadedMessages[indexPath.section][indexPath.row-1];
            //[cell configureWithMessage:message];
/*
            return cell;
        } else
        {
 */
            NSString *cellIdentifier = @"BubbleCell";
            MessageBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[MessageBubbleTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier];
            
            // Add gesture recognizers #CopyMessage
/*
            let action: Selector = #selector(ChatViewController.messageShowMenuAction(_:))
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
            cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
 */
            }
            Message *message = C.LoadedMessages[indexPath.section][indexPath.row-1];
            [cell configureWithMessage:message];
            iChatRow++;

            return cell;
 //       }
    }
}

- (void) createProductArray {
    UIImage *image = [UIImage imageNamed:@"memory.jpg"];
    products[0] = [[Product alloc] initWithImage:image  productDescription:@"Seagate HDD ST2000 2TB"];
}

// MARK: - UITextViewDelegate

-(void) textViewDidChange:(UITextView*) textView{
    //updateTextViewHeight()
    self.Send.enabled = [self.Textview hasText];
}

// MARK: - UIKeyboard Notifications

-(void) keyboardWillShow:(NSNotification*) Not {
    NSDictionary *userInfo = [Not userInfo];
    CGRect keyboardFrameNew = ((NSValue*)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    CGFloat insetNewBottom = [self.ChatView convertRect:keyboardFrameNew fromView: nil].size.height;
    UIEdgeInsets insetOld = self.ChatView.contentInset;
    self.insetChange = insetNewBottom - insetOld.bottom;
    //self.CVConst.constant = 0 - frameNew.size.height;
    CGFloat overflow = self.ChatView.contentSize.height - (self.ChatView.frame.size.height - insetOld.top - insetOld.bottom);
    void (^animations)(void);
    
    double duration = ((NSNumber*)userInfo[UIKeyboardAnimationDurationUserInfoKey]).doubleValue;

    animations = ^{
        if (!(self.ChatView.tracking || self.ChatView.decelerating)) {
            CGPoint oldPoint;
            CGPoint newPoint;
            oldPoint = self.ChatView.contentOffset;
  //          newPoint = CGPointMake(0.0, 100);
  //          [self.ChatView setContentOffset:newPoint animated:YES];
            
            // Move content with keyboard
            if (overflow > 0) {                   // scrollable before
                newPoint = CGPointMake(oldPoint.x, oldPoint.y += self.insetChange);
                [self.ChatView setContentOffset:newPoint animated:YES];
                if (self.ChatView.contentOffset.y < -insetOld.top) {
                    newPoint = CGPointMake(oldPoint.x, -insetOld.top);
                    [self.ChatView setContentOffset:newPoint animated:YES];
                }
            } else if (self.insetChange > -overflow) { // scrollable after
                newPoint = CGPointMake(oldPoint.x, oldPoint.y += self.insetChange + overflow);
                [self.ChatView setContentOffset:newPoint animated:YES];
            }
        }
    };
    /*
    if (duration > 0) {
        
        NSDictionary *keyboardAnimationDetail = [Not userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:animations completion:nil];
    } else {
        animations();
    }
    */
}

-(void) keyboardDidShow:(NSNotification*)Not {
    NSDictionary *userInfo = [Not userInfo];
    self.KeyboardFrame = ((NSValue*)userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    NSLog(@"%@", NSStringFromCGRect(self.KeyboardFrame));
    CGRect frameNew = self.KeyboardFrame;
    CGFloat insetNewBottom = [self.ChatView convertRect:frameNew fromView: nil].size.height;
    
    CGPoint newPoint;
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    self.oldContentOffset = self.ChatView.contentOffset.y;
    //newPoint = CGPointMake(0.0, -navHeight -20 ); // 20pt for status bar.
//    [self.ChatView reloadData];
    //newPoint = CGPointMake(0.0, -64.0);
/*    [UIView animateWithDuration:2.0 animations:^{
        [self.ChatView setContentOffset:newPoint animated:YES];
    }];
*/
    // Inset `tableView` with keyboard
    CGFloat contentOffsetY = self.ChatView.contentOffset.y;
    UIEdgeInsets insetOld = self.ChatView.contentInset;
    UIEdgeInsets insetNew = UIEdgeInsetsMake(insetOld.top, insetOld.left, insetNewBottom, insetOld.right);
    self.ChatView.contentInset = insetNew;
    
    insetOld = self.ChatView.scrollIndicatorInsets;
    insetNew = UIEdgeInsetsMake(insetOld.top, insetOld.left, insetNewBottom, insetOld.right);
    self.ChatView.scrollIndicatorInsets = insetNew;
    // Prevents jump after keyboard dismissal
    
    CGPoint oldPoint = self.ChatView.contentOffset;
    newPoint = CGPointMake(oldPoint.x, contentOffsetY);
    
    [self tableViewScrollToBottomAnimated:YES];
    if (self.ChatView.tracking || self.ChatView.decelerating) {
        [self.ChatView setContentOffset:newPoint animated:YES];
    }
}

// MARK: - Actions

-(void) sendMessageAction {
        // Autocomplete text before sending #hack
    [self.Textview resignFirstResponder];
    [self.Textview becomeFirstResponder];
        

    //NSString *message = @"Like Wow.  Where u at?";
    NSString *text = [self.Textview.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    // To Server
    NSString *UserToMessage;
    UserToMessage = [self appDelegate].UserMessaged;
    XMPPJID *senderJID = [XMPPJID jidWithString:UserToMessage];
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:senderJID];
    
    [msg addBody:text];
    [[self xmppStream] sendElement:msg];
    
    // On Client
    NSDate *date = [NSDate date];

    NSMutableArray *ArrMsg = [NSMutableArray arrayWithObjects:[[Message alloc] initWithIncoming:false text:text sentdate:date], nil];
   
    
    [C.LoadedMessages addObject:ArrMsg];
    C.Lastmessagetext = text;
    C.Lastmessagesentdate = date;

    //NSNotificationCenter.defaultCenter().postNotificationName(AccountDidSendMessageNotification, object: chat)
        
    self.Textview.text = nil;
        //updateTextViewHeight()
    self.Send.enabled = NO;
    
    NSInteger lastSection = self.ChatView.numberOfSections;
    [self.ChatView beginUpdates];
    [self.ChatView insertSections:[[NSIndexSet alloc] initWithIndex: lastSection] withRowAnimation: UITableViewRowAnimationAutomatic];
    [self.ChatView insertRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:0 inSection: lastSection], [NSIndexPath indexPathForRow: 1 inSection: lastSection], nil]  withRowAnimation: UITableViewRowAnimationAutomatic];
    [self.ChatView endUpdates];
    [self.ChatView reloadData];
    [self tableViewScrollToBottomAnimated:YES];
    }

// MARK: - UITableViewDelegate
-(void) tableViewScrollToBottomAnimated:(BOOL)animated {
    NSInteger numOfSections;
    numOfSections = self.ChatView.numberOfSections;
    if (numOfSections > 0)
    {
        NSInteger numberOfRows = [self.ChatView numberOfRowsInSection:numOfSections-1];
        NSInteger lastSection = self.ChatView.numberOfSections;
        if (numberOfRows > 0) {
            [self.ChatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection: lastSection -1] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    }
}
    // Handle actions #CopyMessage
    // 1. Select row and show "Copy" menu
/*    func messageShowMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        if doubleTap || longPress {
            let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)
            
            let menuController = UIMenuController.sharedMenuController()
            let bubbleImageView = gestureRecognizer.view!
            menuController.setTargetRect(bubbleImageView.frame, inView: bubbleImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: #selector(ChatViewController.messageCopyTextAction(_:)))]
            menuController.setMenuVisible(true, animated: true)
        }
    }
*/    // 2. Copy text to pasteboard
/*    func messageCopyTextAction(menuController: UIMenuController) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        let selectedMessage = chat.loadedMessages[selectedIndexPath!.section][selectedIndexPath!.row-1]
        UIPasteboard.generalPasteboard().string = selectedMessage.text
    }
*/    // 3. Deselect row
/*    func menuControllerWillHide(notification: NSNotification) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        (notification.object as! UIMenuController).menuItems = nil
    }
}
*/
- (void) newMessageReceived:(NSDictionary *)messageContent
{
    //NSString *message = @"Like Wow.  Where u at?";
    NSString *text;
    text = [messageContent objectForKey:@"msg"];

    NSDate *date = [NSDate date];
    
    NSMutableArray *ArrMsg = [NSMutableArray arrayWithObjects:[[Message alloc] initWithIncoming:true text:text sentdate:date], nil];
    
    
    [C.LoadedMessages addObject:ArrMsg];
    C.Lastmessagetext = text;
    C.Lastmessagesentdate = date;
    
    //NSNotificationCenter.defaultCenter().postNotificationName(AccountDidSendMessageNotification, object: chat)
    
    self.Textview.text = nil;
    //updateTextViewHeight()
    self.Send.enabled = NO;
    
    NSInteger lastSection = self.ChatView.numberOfSections;
    [self.ChatView beginUpdates];
    [self.ChatView insertSections:[[NSIndexSet alloc] initWithIndex: lastSection] withRowAnimation: UITableViewRowAnimationAutomatic];
    [self.ChatView insertRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:0 inSection: lastSection], [NSIndexPath indexPathForRow: 1 inSection: lastSection], nil]  withRowAnimation: UITableViewRowAnimationAutomatic];
    [self.ChatView endUpdates];
    [self.ChatView reloadData];
    [self tableViewScrollToBottomAnimated:YES];
}
@end
