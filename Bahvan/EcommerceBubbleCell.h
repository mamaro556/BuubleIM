//
//  EcommerceBubbleCell.h
//  Bahvan
//
//  Created by Marvin Amaro on 5/15/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface EcommerceBubbleCell : UITableViewCell
@property (strong, nonatomic) UIImageView *bubbleImageView;
@property (strong, nonatomic) UILabel *messageLabel;

-(void) configureWithMessage:(Message *)message;
@end

@interface UIImageView()

-(UIImage*) imageWithRed:(CGFloat)red green:(CGFloat) green blue:(CGFloat) blue alpha:(CGFloat) alpha;

@end
