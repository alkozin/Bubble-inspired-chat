//
//  View+AnimatedMessageBubble.m
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "UIView+AnimatedMessageBubble.h"

#import "UIView+Utils.h"

#import <QuartzCore/CALayer.h>

@implementation UIView (AnimatedMessageBubble)

- (void)startBubbleAnimationWithDuration:(NSTimeInterval)duration
                                   color:(UIColor *)color
{
    CGFloat radius = [self cornerRadius];

    UIBezierPath *startPath = [self startPath];
    UIBezierPath *endPath = [self endPath];

    // Animation should starts slowly, but ends fast for next animation step
    CAMediaTimingFunction *animationCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    // Create path changing animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    [pathAnimation setFromValue:(__bridge id)startPath.CGPath];
    [pathAnimation setToValue:(__bridge id)endPath.CGPath];
    [pathAnimation setDuration:duration];
    [pathAnimation setRemovedOnCompletion:YES];
    [pathAnimation setDelegate:self];
    [pathAnimation setTimingFunction:animationCurve];

    // Create layer for vizualization
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    [shapeLayer addAnimation:pathAnimation forKey:@"animationKey"];
    [shapeLayer setPath:[endPath CGPath]];

    [shapeLayer setBounds:CGPathGetBoundingBox(shapeLayer.path)];
    [shapeLayer setFillColor:color.CGColor];
    [shapeLayer setLineWidth:0];

    // Layer have extra height on the bottom equals to 1 radius
    [shapeLayer setPosition:CGPointMake(self.width / 2.0, self.height / 2.0 + radius)];

    [self.layer insertSublayer:shapeLayer atIndex:0];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [[self.layer.sublayers firstObject] removeFromSuperlayer];
}

- (UIBezierPath *)startPath
{
    CGFloat radius = [self cornerRadius];

    // Prepare left points
    CGPoint left_Top = (CGPoint){radius, 0.0};

    CGPoint left_Top_Control = left_Top;
    left_Top_Control.x = -radius / 2.0;

    CGPoint left_Bottom = (CGPoint){-radius * 2, 0.f};

    CGPoint left_Bottom_Control = left_Bottom;
    left_Bottom_Control.x = 0.0;

    CGPoint left_Bound = left_Bottom;
    left_Bound.y = self.height + radius * 2;

    // Prepare right points
    CGPoint right_Top = (CGPoint){self.width - radius, 0.0};

    CGPoint right_Top_Control = right_Top;
    right_Top_Control.x = self.width + radius / 2.0;

    CGPoint right_Bottom = left_Bottom;
    right_Bottom.x = self.width + radius * 2;

    CGPoint right_Bottom_Control = right_Bottom;
    right_Bottom_Control.x = self.width;

    CGPoint right_Bound = right_Bottom;
    right_Bound.y = self.height + radius * 2;

//        lTC-_lT__rT_-rTC
//           /        \
// lB----lBC/          \rBC----rB
//          |          |
//          |          |
//    lBound|__________|rBound

    // Create path
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:left_Top];
    [path addCurveToPoint:left_Bottom
            controlPoint1:left_Top_Control
            controlPoint2:left_Bottom_Control];

    [path addLineToPoint:left_Bound];
    [path addLineToPoint:right_Bound];

    [path addLineToPoint:right_Bottom];

    [path addCurveToPoint:right_Top
            controlPoint1:right_Bottom_Control
            controlPoint2:right_Top_Control];
    
    [path closePath];
    
    return path;
}

- (UIBezierPath *)endPath
{
    CGFloat radius = [self cornerRadius];

    // Prepare left points
    CGPoint left_Top = (CGPoint){radius, 0.0};

    CGPoint left_Top_Control = left_Top;
    left_Top_Control.x = -radius * 1.1;

    CGPoint left_Bottom = (CGPoint){-radius, self.height + radius};

    CGPoint left_Bottom_Control = left_Bottom;
    left_Bottom_Control.x = radius * 1.3;

    CGPoint left_Bound = left_Bottom;
    left_Bound.y = self.height + radius * 2;

    // Prepare right points
    CGPoint right_Top = (CGPoint){self.width - radius, 0.0};

    CGPoint right_Top_Control = right_Top;
    right_Top_Control.x = self.width + radius * 1.1;

    CGPoint right_Bottom = left_Bottom;
    right_Bottom.x = self.width + radius;

    CGPoint right_Bottom_Control = right_Bottom;
    right_Bottom_Control.x = self.width - radius * 1.3;

    CGPoint right_Bound = right_Bottom;
    right_Bound.y = self.height + radius * 2;

//      lTC---_lT__rT_---rTC
//           /        \
//           /        \
//           /        \
//      lB--/-lBC  rBC-\-rB
//    lBound|__________|rBound

    // Create path
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:left_Top];
    [path addCurveToPoint:left_Bottom
            controlPoint1:left_Top_Control
            controlPoint2:left_Bottom_Control];

    [path addLineToPoint:left_Bound];
    [path addLineToPoint:right_Bound];

    [path addLineToPoint:right_Bottom];

    [path addCurveToPoint:right_Top
            controlPoint1:right_Bottom_Control
            controlPoint2:right_Top_Control];

    [path closePath];

    return path;
}

- (CGFloat)cornerRadius
{
    return self.height / 2.0;
}

@end
