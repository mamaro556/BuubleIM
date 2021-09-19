//
//  MessageBubbleTableViewCell.h
//  Bahvan
//
//  Created by MacOwner on 12/21/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface MessageBubbleTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *bubbleImageView;
@property (strong, nonatomic) UILabel *messageLabel;

-(void) configureWithMessage:(Message *)message;
@end

@interface UIImageView()

-(UIImage*) imageWithRed:(CGFloat)red green:(CGFloat) green blue:(CGFloat) blue alpha:(CGFloat) alpha;

@end