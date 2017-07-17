//
//  TYBaseViewController.m
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation TYBaseViewController


#pragma mark - setter methods
- (void)setCanDragBack:(BOOL)canDragBack {
    _canDragBack = canDragBack;
    if (canDragBack) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    } else {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
#pragma mark - 找到当前ViewController的第一响应者
- (UIView *)findFirstResponderInView:(UIView *)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView *firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

- (UIView *)findFirstResponder {
    UIView *view = [self findFirstResponderInView:self.view];
    if (view) {
        return view;
    } else {
        return [self findFirstResponderInView:self.navigationController.navigationBar];
    }
}
#pragma mark - remove observer
- (void)removeNotificationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
