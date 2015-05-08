//
//  UIView+GetViewController.m
//  MoveGrid
//
//  Created by 胡晓桥 on 15/3/26.
//  Copyright (c) 2015年 51app. All rights reserved.
//

#import "UIView+GetViewController.h"

@implementation UIView (GetViewController)

- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
