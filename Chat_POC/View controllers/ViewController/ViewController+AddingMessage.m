//
//  ViewController+AddingMessage.m
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "ViewController_Private.h"

#import "MessageCell.h"
#import "UIView+AnimatedMessageBubble.h"

@implementation ViewController (AddingMessage)

/**
 *  Adds new user message to view animated
 *  Firstly add message to table view
 *  Then scroll table to make this area visible
 *  Hide real message cell
 *  And add message showing animation
 *
 *  @param message Message to add
 */
- (void)addMessage:(NSString *)message
{
    [self.messages addObject:message];
    [self.tableView reloadData];

    [self scrollTableToNewMessage];
    [self hideCellContent];

    // reloadData is async metod, quick hack for little delay
    // TODO: should be rewritten
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addNewMessageShowingAnimation];
    });
}

// TODO: refactor and split to few methods
/**
 *  Creates new message animation
 *  Animation should be created using two steps
 *  First step is when it moves from text field with bubble inspired animation
 *  Second is when it moves to final position
 */
- (void)addNewMessageShowingAnimation
{
    UIView *animationView = [self animationView];
    UITableView *tableView = self.tableView;
    UITextField *addMessageTextField = self.addMessageTextField;

    // Stop receiving interaction events
    [tableView setUserInteractionEnabled:NO];

    // Message cell is last added cell
    MessageCell *messageCell = [tableView.visibleCells lastObject];

    CGRect startAnimationRect = [self startAnimationRectForCell:messageCell];
    CGRect finalAnimationRect = [self finalRectForCell:messageCell];
    CGRect intermediateRect = [self intermediateRectForStart:startAnimationRect andEnd:finalAnimationRect];

    // Clone messageContainer for preventing glithes
    UIView *bubbleView = [messageCell.contentContainer clone];
    [bubbleView setHidden:NO];

    // Turn off autolayout for message bubble
    [bubbleView setTranslatesAutoresizingMaskIntoConstraints:YES];

    // Make rounded corners
    // We should add another view to prevent cropping bezier animations
    UIView *cornerView = [self addCornerViewTo:bubbleView];

    // Show message bubble on start position
    [bubbleView setFrame:startAnimationRect];
    [animationView addSubview:bubbleView];

    // Hide textField
    [addMessageTextField setAlpha:0.0];
    [addMessageTextField setText:nil];

    // Start first animation when bubble trying to move from container
    NSTimeInterval firstStepDuration = 0.9;
    [UIView animateWithDuration:firstStepDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         UIColor *bubbleColor = self.addMessageView.backgroundColor;
                         [bubbleView setFrame:intermediateRect];
                         [bubbleView startBubbleAnimationWithDuration:firstStepDuration
                                                                color:bubbleColor];
                     } completion:^(BOOL finished_first) {
                         // Start second animation when bubble moves to final location
                         NSTimeInterval finalStepDuration = 0.8;
                         [UIView animateWithDuration:finalStepDuration
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // Show textField
                                              [addMessageTextField setAlpha:1.0];
                                              [bubbleView setFrame:finalAnimationRect];

                                              // Remove corner
                                              [cornerView setCornerRadius:0.0
                                                                 animated:YES
                                                             withDuration:finalStepDuration];
                                          } completion:^(BOOL finished_second) {
                                              // Remove animated bubble
                                              [bubbleView removeFromSuperview];

                                              // Show message in cell
                                              [messageCell.contentContainer setHidden:NO];

                                              // Turn on interaction
                                              [tableView setUserInteractionEnabled:YES];
                                          }];
                     }];
}

- (void)scrollTableToNewMessage
{
    UITableView *tableView = self.tableView;

    CGFloat height = tableView.bounds.size.height;
    CGSize contentSize = tableView.contentSize;
    UIEdgeInsets inset = tableView.contentInset;

    CGFloat maxContentOffsetY;
    // If all content are visible on one screen just scroll to top
    if (contentSize.height + inset.bottom + inset.top < height) {
        maxContentOffsetY = -inset.top;
    } else {
        // Otherwise scroll to tableView bottom
        maxContentOffsetY = contentSize.height - height + inset.bottom;
    }

    [tableView setContentOffset:CGPointMake(0, maxContentOffsetY) animated:YES];
}

- (void)hideCellContent
{
    MessageCell *messageCell = [self.tableView.visibleCells lastObject];
    [messageCell.contentContainer setHidden:YES];
}

- (UIView *)addCornerViewTo:(UIView *)messageContainer
{
    UIView *cornerView = [UIView viewWithFrame:messageContainer.bounds];
    [cornerView setBackgroundColor:messageContainer.backgroundColor];
    [messageContainer setBackgroundColor:[UIColor clearColor]];
    [messageContainer insertSubview:cornerView atIndex:0];

    CGFloat cornerRadius = messageContainer.height / 2.0;
    [cornerView setCornerRadius:cornerRadius];

    return cornerView;
}

/**
 *  Calculates start rect in animationView
 *
 *  @param messageCell Cell in table for calculations
 *
 *  @return Start animation rect
 */
- (CGRect)startAnimationRectForCell:(MessageCell *)messageCell
{
    CGRect startAnimationRect = messageCell.contentContainer.frame;

    UIView *animationView = [self animationView];
    UITextField *addMessageTextField = self.addMessageTextField;

    CGPoint startAnimationOrigin = [animationView convertPoint:addMessageTextField.frame.origin
                                                      fromView:addMessageTextField.superview];
    // Move container for removing margins
    // Not so good solution, can be improved
    UIView *messageLabel = messageCell.messageLabel;
    startAnimationOrigin.x -= messageLabel.x;
    startAnimationOrigin.y -= messageLabel.y;

    startAnimationRect.origin = startAnimationOrigin;

    return startAnimationRect;
}

/**
 *  Calculates intermediate rect in animationView
 *  This is first animation step end point and second start point
 *
 *  @param startAnimationRect Whole animation start point
 *  @param finalAnimationRect Whole animation end point
 *
 *  @return Intermediate animation rect
 */
- (CGRect)intermediateRectForStart:(CGRect)startAnimationRect andEnd:(CGRect)finalAnimationRect
{
    CGRect intermediateRect;

    CGPoint startAnimationOrigin = startAnimationRect.origin;
    // Calculate intermediate animation point when bubble left message container
    // Y is always higher than start Y  for bubble height and margin
    CGFloat intermediateY = startAnimationOrigin.y -
                            startAnimationRect.size.height -
                            CGRectGetHeight(startAnimationRect) / 2;
    // X should be calculated from Y value
    // We should find how far is Y from start and calculate equal far value X
    // Should be calculated from proportion ( dYi / dY = dXi / dX)
    CGFloat intermediateX = (finalAnimationRect.origin.x - startAnimationOrigin.x) *
    (intermediateY - startAnimationOrigin.y)  /
    (finalAnimationRect.origin.y - startAnimationOrigin.y);

    intermediateRect.origin = (CGPoint){intermediateX, intermediateY};
    intermediateRect.size = finalAnimationRect.size;

    return intermediateRect;
}

/**
 *  Calculates final rect in animationView
 *  We can't get it directly because tableView is scrollig in this moment
 *
 *  @param messageCell Cell in table for calculations
 *
 *  @return Final animation rect
 */
- (CGRect)finalRectForCell:(MessageCell *)messageCell
{
    CGRect finalRect;

    UITableView *tableView = self.tableView;
    UIView *messageContainer = messageCell.contentContainer;

    CGSize contentSize = tableView.contentSize;
    UIEdgeInsets inset = tableView.contentInset;

    finalRect = messageContainer.frame;
    finalRect.origin.y = ({
        CGFloat finalRectY;
        if (contentSize.height + inset.bottom + inset.top > tableView.height) {
            finalRectY = tableView.height - inset.bottom;
        } else {
            finalRectY = contentSize.height;
        }
        finalRectY -= messageCell.height;

        finalRectY;
    });

    return finalRect;
}

- (UIView *)animationView
{
    return self.view;
}

@end
