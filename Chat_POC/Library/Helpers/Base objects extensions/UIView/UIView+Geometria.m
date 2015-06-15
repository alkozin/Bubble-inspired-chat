//
//  UIView+Geometria.m
//  Sliker
//
//  Created by Alko on 6/25/13.
//  Copyright (c) 2013 company. All rights reserved.
//

#import "UIView+Utils.h"

#import <QuartzCore/CALayer.h>

@implementation UIView (Geometria)

- (void)setCornerRadius:(CGFloat)cornerRadius animated:(BOOL)animated withDuration:(NSTimeInterval)duration
{
    if (animated) {
        CALayer *layer = self.layer;

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @(layer.cornerRadius);
        animation.toValue = @(cornerRadius);
        animation.duration = duration;

        [layer addAnimation:animation forKey:@"cornerRadius"];
        [layer setCornerRadius:cornerRadius];
    } else {
        [self setCornerRadius:cornerRadius];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    CALayer *layer = self.layer;
    [layer setCornerRadius:cornerRadius];
    [layer setMasksToBounds:YES];
}

- (void)makeItCircle
{
    [self setCornerRadius:self.width / 2.f];
}

- (void)removeCornerRadius
{
    CALayer *layer = self.layer;
    [layer setCornerRadius:0.f];
    [layer setMasksToBounds:NO];
}

@end
