//
//  ViewController+TableView.m
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import "ViewController_Private.h"

#import "MessageCell.h"

@implementation ViewController (TableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = (NSInteger)self.messages.count;
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MessageCell";

    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSUInteger row = (NSUInteger)indexPath.row;
    NSString *message = self.messages[row];
    [cell.messageLabel setText:message];

    return cell;
}

@end
