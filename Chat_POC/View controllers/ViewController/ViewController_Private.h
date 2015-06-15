//
//  ViewController_Private.h
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "ViewController.h"

#import "UIView+Utils.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *addMessageView;
@property (weak, nonatomic) IBOutlet UITextField *addMessageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addMessageViewBottomConstraint;

@property (strong, nonatomic) NSMutableArray *messages;

@end

@interface ViewController (AddingMessage)

/**
 *  Adds message from user to messages table
 *
 *  @param message Text message to add
 */
- (void)addMessage:(NSString *)message;

@end

@interface ViewController (TableView) <UITableViewDataSource, UITableViewDelegate>

@end

@interface ViewController (TextField) <UITextFieldDelegate>

@end
