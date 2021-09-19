//
//  ChatTableViewCell.m
//  Bahvan
//
//  Created by MacOwner on 12/20/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "ChatTableViewCell.h"
#import <UIKit/UIKit.h>
#import "UserPictureImageView.h"

@implementation ChatTableViewCell


CGFloat chatTableViewCellHeight = 72;
CGFloat chatTableViewCellInsetLeft;


UserPictureImageView *userPictureImageView;
UILabel *userNameLabel;
UILabel *lastMessageTextLabel;
UILabel *lastMessageSentDateLabel;
    
-(id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier {
    
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        chatTableViewCellInsetLeft = chatTableViewCellHeight + 8;

        userPictureImageView = [[UserPictureImageView alloc ]initWithFrame: CGRectMake(8, (chatTableViewCellHeight-64)/2, 64, 64)];
 
    userNameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    userNameLabel.backgroundColor = [UIColor whiteColor];
    userNameLabel.font = [UIFont systemFontOfSize:17];
    
    lastMessageTextLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        lastMessageTextLabel.backgroundColor = [UIColor whiteColor];
    lastMessageTextLabel.font = [UIFont systemFontOfSize:15];
    lastMessageTextLabel.numberOfLines = 2;
    lastMessageTextLabel.textColor = [UIColor colorWithRed: 142/255 green: 142/255 blue: 147/255 alpha: 1];
    
    lastMessageSentDateLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    lastMessageSentDateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    lastMessageSentDateLabel.backgroundColor = [UIColor whiteColor];
    lastMessageSentDateLabel.font = [UIFont systemFontOfSize:15];
    lastMessageSentDateLabel.textColor = lastMessageTextLabel.textColor;

        [self.contentView addSubview:userPictureImageView];
        [self.contentView addSubview:userNameLabel];
        [self.contentView addSubview:lastMessageTextLabel];
        [self.contentView addSubview:lastMessageSentDateLabel];

    userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: userNameLabel attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeLeft multiplier: 1 constant: chatTableViewCellInsetLeft]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: userNameLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1 constant: 6]];
    
    lastMessageTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageTextLabel attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual  toItem:userNameLabel attribute: NSLayoutAttributeLeft multiplier: 1 constant: 0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageTextLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual  toItem:self.contentView attribute: NSLayoutAttributeTop multiplier: 1 constant: 28]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageTextLabel attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual  toItem:self.contentView attribute: NSLayoutAttributeRight multiplier: 1 constant: -7]];
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageTextLabel attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual  toItem:self.contentView attribute: NSLayoutAttributeTop multiplier: 1 constant: -4]];
    

    lastMessageSentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageSentDateLabel attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual  toItem:userNameLabel attribute: NSLayoutAttributeRight multiplier: 1 constant: 2]];
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageSentDateLabel attribute: NSLayoutAttributeRight relatedBy: NSLayoutRelationEqual  toItem:self.contentView attribute: NSLayoutAttributeRight multiplier: 1 constant: -7]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: lastMessageSentDateLabel attribute: NSLayoutAttributeBaseline relatedBy: NSLayoutRelationEqual  toItem:userNameLabel attribute: NSLayoutAttributeBaseline multiplier: 1 constant: 0]];
    }
    return self;

}

/*
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 func configureWithChat(chat: Chat) {
 let user = chat.user
 userPictureImageView.configureWithUser(user)
 userNameLabel.text = user.name
 lastMessageTextLabel.text = chat.lastMessageText
 lastMessageSentDateLabel.text = chat.lastMessageSentDateString
 }
 */

@end
