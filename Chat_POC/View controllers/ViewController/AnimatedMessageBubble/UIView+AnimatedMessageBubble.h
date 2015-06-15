//
//  View+AnimatedMessageBubble.h
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//



@interface UIView (AnimatedMessageBubble)

/**
 *  Starts specific water bubble inspired animation
 *
 *  @param duration Duration of animation
 *  @param color    Color of animated bubble
 */
- (void)startBubbleAnimationWithDuration:(NSTimeInterval)duration
                                   color:(UIColor *)color;

@end
