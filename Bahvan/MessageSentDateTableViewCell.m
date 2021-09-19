//
//  MessageSentDateTableViewCell.m
//  Bahvan
//
//  Created by MacOwner on 12/25/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "MessageSentDateTableViewCell.h"

@implementation MessageSentDateTableViewCell


-(id) initWithStyle:(UITableViewCellStyle) style reuseIdentifier: (NSString*) reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
    self.sentDateLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    self.sentDateLabel.backgroundColor = [UIColor clearColor];
    self.sentDateLabel.font = [UIFont systemFontOfSize:11 ];
    self.sentDateLabel.textAlignment = NSTextAlignmentCenter;
    self.sentDateLabel.textColor = [UIColor colorWithRed: 142/255 green: 142/255 blue: 147/255 alpha: 1];
        
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.sentDateLabel];
        
        // Flexible width autoresizing causes text to jump because center text alignment doesn't animate
    self.sentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.sentDateLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeCenterX multiplier: 1 constant:0]];

    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.sentDateLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1 constant: 13]];
    
    [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.sentDateLabel attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1 constant: -4.5]];

    }
/*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
    return self;
}

@end
