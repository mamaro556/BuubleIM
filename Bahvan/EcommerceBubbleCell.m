//
//  EcommerceBubbleTableViewCell.m
//  Bahvan
//
//  Created by Mark Amaro on 5/15/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EcommerceBubbleCell.h"
#import "UIImage+ImageWithRed.h"
//#import "ChatViewController.h"

@implementation EcommerceBubbleCell
NSInteger incomingTagx = 0;
NSInteger outgoingTagx = 1;
NSInteger bubbleTagx = 8;

static CGFloat chatMessageFontSiz = 17.0;
UIImage *incomingx;
UIImage *incomingHighlightedx;
UIImage *outgoingx;
UIImage *outgoingHighlightedx;
/*
static let bubbleImage: (incoming: UIImage, incomingHighlighed: UIImage, outgoing: UIImage, outgoingHighlighed: UIImage) = {
    let maskOutgoing = UIImage(named: "MessageBubble")!
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage!, scale: 2, orientation: .UpMirrored)
    
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    
 
    return (incoming, incomingHighlighted, outgoing, outgoingHighlighted)
}()
*/

-(id) initWithStyle: (UITableViewCellStyle) style reuseIdentifier:(NSString *) reuseIdentifier {
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        UIImage *maskOutgoing = [UIImage imageNamed:@"MessageBubble"];
        UIImage *maskIncoming = [UIImage imageWithCGImage: maskOutgoing.CGImage scale:2 orientation: UIImageOrientationUpMirrored];
    
        UIEdgeInsets capInsetsIncoming = UIEdgeInsetsMake(17, 26.5, 17.5, 21);
        UIEdgeInsets capInsetsOutgoing = UIEdgeInsetsMake(17, 21, 17.5, 26.5);

        incomingx = [[maskIncoming imageWithRed:229.0/255 green: 229.0/255 blue: 234.0/255 alpha: 1.0] resizableImageWithCapInsets:capInsetsIncoming];
        incomingHighlightedx = [[maskIncoming imageWithRed:206/255 green: 206/255 blue: 210/255 alpha: 1] resizableImageWithCapInsets:capInsetsIncoming];
        outgoingx = [[maskOutgoing imageWithRed:43.0/255 green: 119.0/255 blue: 250.0/255 alpha: 1.0] resizableImageWithCapInsets:capInsetsOutgoing ];
        outgoingHighlightedx = [[maskOutgoing imageWithRed:32/255 green: 96/255 blue: 200/255 alpha: 1] resizableImageWithCapInsets:capInsetsOutgoing];
        
        self.bubbleImageView = [[UIImageView alloc]initWithImage:incomingx highlightedImage:incomingHighlightedx];
        self.bubbleImageView.tag = bubbleTagx;
        //bubbleImageView.userInteractionEnabled = true // #CopyMesage
        
        self.messageLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        
        //self.messageLabel.font = [UIFont systemFontOfSize:[17.0]];
        self.messageLabel.numberOfLines = 0;
        //messageLabel.userInteractionEnabled = false   // #CopyMessage
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.bubbleImageView];
        [self.bubbleImageView addSubview:self.messageLabel];
        
        self.bubbleImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.messageLabel.preferredMaxLayoutWidth = 218;
        
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeLeft multiplier: 1 constant:10]];
        
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeTop multiplier: 1 constant: 4.5]];

        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual  toItem: self.messageLabel attribute: NSLayoutAttributeWidth multiplier: 1 constant: 30]];

        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1 constant: -4.5]];

        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeCenterX multiplier: 1 constant: 3]];
        
        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeCenterY multiplier: 1 constant: -0.5]];
        
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeHeight multiplier: 1 constant: -28]];


    }
    return self;
}
/*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
-(void) configureWithMessage:(Message *)message {
    self.messageLabel.text = message.Text;
    
        if (message.Incoming != (self.tag == incomingTagx) ){
            NSLayoutAttribute layoutAttribute;
            CGFloat layoutConstant;
            
            if (message.Incoming) {
                self.tag = incomingTagx;
                self.bubbleImageView.image = incomingx;
                self.bubbleImageView.highlightedImage = incomingHighlightedx;
                self.messageLabel.textColor = [UIColor blackColor];
                layoutAttribute = NSLayoutAttributeLeft;
                layoutConstant = 10;
            } else { // outgoing
                self.tag = outgoingTagx;
                self.bubbleImageView.image = outgoingx;
                self.bubbleImageView.highlightedImage = outgoingHighlightedx;
                self.messageLabel.textColor = [UIColor whiteColor];
                layoutAttribute = NSLayoutAttributeRight;
                layoutConstant = -10;
            }
            
            NSLayoutConstraint *layoutConstraint = self.bubbleImageView.constraints[1]; // `messageLabel` CenterX
            layoutConstraint.constant = -layoutConstraint.constant;
            
            NSArray *constraints = self.contentView.constraints;
            
            NSUInteger indexOfConstraint = [constraints indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop)
            {
                UIView *uIV = ((UIView*)((NSLayoutConstraint*)obj).firstItem);
                NSLayoutAttribute lA = ((NSLayoutConstraint*)obj).firstAttribute;
                BOOL b = (uIV.tag == bubbleTagx && ( lA == NSLayoutAttributeLeft || lA == NSLayoutAttributeRight));
                return b;
            }];

            [self.contentView removeConstraint:(NSLayoutConstraint *)constraints[indexOfConstraint]];
            
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem: self.bubbleImageView  attribute: layoutAttribute  relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute:layoutAttribute multiplier: 1 constant:layoutConstant]];
            
            
            /*let indexOfConstraint = constraints.indexOfObjectPassingTest { constraint, idx, stop in
                return (constraint.firstItem as! UIView).tag == bubbleTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
            }
             
            contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
            contentView.addConstraint(NSLayoutConstraint(item: bubbleImageView, attribute: layoutAttribute, relatedBy: .Equal, toItem: contentView, attribute: layoutAttribute, multiplier: 1, constant: layoutConstant))
        */
        }
    }
    
    // Highlight cell #CopyMessage
/* override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected
    }*/
@end
