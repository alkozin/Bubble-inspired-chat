//
//  NSObject+Notifications.m
//
//  Created by алко on 8/13/12.
//  Copyright (c) 2012 Siberian.pro. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Notifications)

- (void)addKeyboardWillShowNotificationObserver:(void (^)(CGFloat height))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      NSDictionary *info = [note userInfo];
                                                      CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                                                      if (block) {
                                                          block(keyboardSize.height);
                                                      }
                                                  }];
}

- (void)addKeyboardWillHideObserver:(void (^)(void))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      if (block) {
                                                          block();
                                                      }
                                                  }];
}

- (void)addNotificationObserver:(NSString*)name usingBlock:(void (^)(NSNotification *note))block
{
    [[NSNotificationCenter defaultCenter] addObserverForName:name object:nil queue:nil usingBlock:block];
}

- (void)addMemoryWarningObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification*)n
{
}

- (void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString*)name
{
    [self postNotification:name withInfo:nil];
}

- (void)postNotification:(NSString*)name withInfo:(NSDictionary*)info
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:info];
}

@end
