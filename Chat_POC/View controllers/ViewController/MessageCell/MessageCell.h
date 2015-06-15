//
//  MessageCell.h
//  Chat_POC
//
//  Created by Alexander Kozin on 03.06.15.
//  Copyright (c) 2015 Siberian.pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end
