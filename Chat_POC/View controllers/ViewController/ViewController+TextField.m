//
//  ViewController+TextField.m
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "ViewController_Private.h"

@implementation ViewController (TextField)

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // TODO: fix glith when posting few messages in row and remove if
    if (self.tableView.isUserInteractionEnabled) {
        [self addMessage:textField.text];
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent from adding symbols while animation in process
    BOOL shouldChange = YES;

    // TODO: change if condition to normal flag
    if (mEqualzero(textField.alpha)) {
        shouldChange = NO;
    }

    return shouldChange;
}

@end
