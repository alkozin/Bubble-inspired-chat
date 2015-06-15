//
//  ViewController.m
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "ViewController_Private.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createStabMessages];
    [self prepareKeyboard];

    // Uncomment for auto sending message on start
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self addMessage:@"Ghjkjub"];
//    });
}

- (void)createStabMessages
{
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:2];
    [messages addObject:@"Hello, world!"];
    [messages addObject:@"May the Force be with you"];

    [self setMessages:messages];
}

- (void)prepareKeyboard
{
    UITableView *tableView = self.tableView;
    UITextField *addMessageTextField = self.addMessageTextField;
    NSLayoutConstraint *addMessageBottomConstraint = self.addMessageViewBottomConstraint;

    [self addKeyboardWillShowNotificationObserver:^(CGFloat height) {
        // Add inset
        CGFloat bottomInset = self.addMessageView.height + height;

        // Add inset for content with margin
        UIEdgeInsets contentInset = tableView.contentInset;
        contentInset.bottom = bottomInset + kDialogBottomTableAdditionalMargin;
        [tableView setContentInset:contentInset];

        // Add inset for scroll indicator
        UIEdgeInsets scrollInset = contentInset;
        scrollInset.bottom = bottomInset;
        [tableView setScrollIndicatorInsets:scrollInset];

        [addMessageBottomConstraint setConstant:height];
    }];

    [addMessageTextField becomeFirstResponder];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
