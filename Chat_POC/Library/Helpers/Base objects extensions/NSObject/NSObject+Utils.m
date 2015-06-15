//
//  NSObject+Utils.m
//  Test
//
//  Created by Alexander Kozin on 5/2/12.
//  Copyright (c) 2012 Siberian.pro. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

+ (id)controllerFromXib
{
    id object = [self object];
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:object options:nil];
    return object;
}

+ (id)object
{
    return [[self alloc] init];
}

+ (id)objectFromXib
{
    return [self objectFromXib:[self nibName] withOwner:nil];
}

+ (id)objectFromXibWithOwner:(id)owner
{
    return [self objectFromXib:[self nibName] withOwner:owner];
}

+ (id)objectFromXib:(NSString*)nibName withOwner:(id)owner
{
    id cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil] objectAtIndex:0];
    
    return cell;
}

+ (NSString*)nibName
{
    NSString *className = NSStringFromClass([self class]);
    return className;
}

@end
