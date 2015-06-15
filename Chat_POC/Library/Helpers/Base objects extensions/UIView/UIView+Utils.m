//
//  UIView+Utils.m
//
//  Created by Alexander Kozin on 6/15/12.
//  Copyright (c) 2012 Siberian.pro. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

+ (instancetype)viewWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (CGRect)frameInView:(UIView*)view
{
    return [self.superview convertRect:self.frame toView:view];
}

- (CGPoint)centerInView:(UIView*)view
{
    return [self.superview convertPoint:self.center toView:view];
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (instancetype)clone
{
    NSData *archivedViewData = [NSKeyedArchiver archivedDataWithRootObject: self];
    id clone = [NSKeyedUnarchiver unarchiveObjectWithData:archivedViewData];

    return clone;
}

@end
