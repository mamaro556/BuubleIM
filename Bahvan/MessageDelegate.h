//
//  MessageDelegate.h
//  jabberClient
//
//  Created by cesarerocchi on 8/2/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MessageDelegate

- (void)newMessageReceived:(NSDictionary *)messageContent;

@end
