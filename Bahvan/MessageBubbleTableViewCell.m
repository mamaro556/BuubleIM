//
//  MessageBubbleTableViewCell.m
//  Bahvan
//
//  Created by MacOwner on 12/21/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "MessageBubbleTableViewCell.h"
#import "UIImage+ImageWithRed.h"
//#import "ChatViewController.h"

@implementation MessageBubbleTableViewCell
NSInteger incomingTag = 0;
NSInteger outgoingTag = 1;
NSInteger bubbleTag = 8;

static CGFloat chatMessageFontSiz = 17.0;
UIImage *incoming;
UIImage *incomingHighlighted;
UIImage *outgoing;
UIImage *outgoingHighlighted;
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

        incoming = [[maskIncoming imageWithRed:229.0/255 green: 229.0/255 blue: 234.0/255 alpha: 1.0] resizableImageWithCapInsets:capInsetsIncoming];
        incomingHighlighted = [[maskIncoming imageWithRed:206/255 green: 206/255 blue: 210/255 alpha: 1] resizableImageWithCapInsets:capInsetsIncoming];
        outgoing = [[maskOutgoing imageWithRed:43.0/255 green: 119.0/255 blue: 250.0/255 alpha: 1.0] resizableImageWithCapInsets:capInsetsOutgoing ];
        outgoingHighlighted = [[maskOutgoing imageWithRed:32/255 green: 96/255 blue: 200/255 alpha: 1] resizableImageWithCapInsets:capInsetsOutgoing];
        
        self.bubbleImageView = [[UIImageView alloc]initWithImage:incoming highlightedImage:incomingHighlighted];
        self.bubbleImageView.tag = bubbleTag;
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

//        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual  toItem: self.messageLabel attribute: NSLayoutAttributeHeight multiplier: 1 constant: 150]];

        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.bubbleImageView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual  toItem: self.contentView attribute: NSLayoutAttributeBottom multiplier: 1 constant: -4.5]];

        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeCenterX multiplier: 1 constant: 3]];
        
        [self.bubbleImageView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeCenterY multiplier: 1 constant: -0.5]];
        
        [self.contentView addConstraint: [NSLayoutConstraint constraintWithItem: self.messageLabel attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual  toItem: self.bubbleImageView attribute: NSLayoutAttributeHeight multiplier: 1 constant: -15]];


    }
    return self;
}
/*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
-(void) configureWithMessage:(Message *) message {
    self.messageLabel.text = message.Text;
    
        if (message.Incoming != (self.tag == incomingTag) ){
            NSLayoutAttribute layoutAttribute;
            CGFloat layoutConstant;
            
            if (message.Incoming) {
                self.tag = incomingTag;
                self.bubbleImageView.image = incoming;
                self.bubbleImageView.highlightedImage = incomingHighlighted;
                self.messageLabel.textColor = [UIColor blackColor];
                layoutAttribute = NSLayoutAttributeLeft;
                layoutConstant = 10;
            } else { // outgoing
                self.tag = outgoingTag;
                self.bubbleImageView.image = outgoing;
                self.bubbleImageView.highlightedImage = outgoingHighlighted;
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
                BOOL b = (uIV.tag == bubbleTag && ( lA == NSLayoutAttributeLeft || lA == NSLayoutAttributeRight));
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
