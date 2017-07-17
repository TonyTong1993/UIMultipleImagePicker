//
//  ImageHandler.h
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
typedef NS_ENUM(NSInteger,AuthorizationStatus) {
    AuthorizationStatusDetermined = 0,
    AuthorizationStatusRestricted,
    AuthorizationStatusDenied,
    AuthorizationStatusAuthorized,
};
@interface ImageHandler : NSObject
+(AuthorizationStatus)requestAuthorization;
+(void)requestAuthorization:(void (^)(AuthorizationStatus status)) handler;
@end
