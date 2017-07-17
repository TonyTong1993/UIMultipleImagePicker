//
//  TYBaseViewController.h
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYBaseViewController : UIViewController
/**
 * @brief canDragBack: default is YES, if NO, you can't dragBack to last viewController
 */
@property (nonatomic, assign) BOOL canDragBack;

- (UIView *)findFirstResponder;

// 移除监听
- (void)removeNotificationObserver;

@end
