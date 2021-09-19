//
//  UserPictureImageView.m
//  Bahvan
//
//  Created by MacOwner on 12/20/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "UserPictureImageView.h"

@implementation UserPictureImageView
UILabel *userNameInitialsLabel;

-(id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        userNameInitialsLabel = [[UILabel alloc] initWithFrame: CGRectZero];

        self.backgroundColor = [UIColor colorWithRed: 199/255 green: 199/255 blue: 204/255 alpha: 1];
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
        
        userNameInitialsLabel.font = [UIFont systemFontOfSize:frame.size.width/2+1];
        userNameInitialsLabel.textAlignment = NSTextAlignmentCenter;
        userNameInitialsLabel.textColor = [UIColor whiteColor];
        [self addSubview:userNameInitialsLabel];
        
        userNameInitialsLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint: [NSLayoutConstraint constraintWithItem: userNameInitialsLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual  toItem: self attribute: NSLayoutAttributeCenterX multiplier: 1 constant: 0]];
        
        [self addConstraint: [NSLayoutConstraint constraintWithItem: userNameInitialsLabel attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterY multiplier: 1 constant: -1]];
    }
    return self;
}
/*
-(void) configureWithUser:(User*)user{
    if let pictureName = user.pictureName() {
        image = UIImage(named: pictureName)
        userNameInitialsLabel.hidden = true
        return
    }
    if let initials = user.initials {
        image = nil
        userNameInitialsLabel.hidden = false
        userNameInitialsLabel.text = initials
        return
    }
    image = UIImage(named: "User0")
    userNameInitialsLabel.hidden = true
}
*/
@end
