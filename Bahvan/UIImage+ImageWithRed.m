//
//  UIImageView+ImageWithRed.m
//  Bahvan
//
//  Created by MacOwner on 12/21/16.
//  Copyright © 2016 Bahvan. All rights reserved.
//

#import "UIImage+ImageWithRed.h"

@implementation UIImage (ImageWithRed)
-(UIImage*) imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat) alpha
{
    CGRect rect = CGRectMake(0, 0, self.size.width , self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
