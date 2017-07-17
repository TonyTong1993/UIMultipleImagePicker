//
//  ImageHandler.m
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "ImageHandler.h"
#import "Config.h"
@implementation ImageHandler
+(AuthorizationStatus)requestAuthorization {
    if (iOS8Upwards) {
        return (AuthorizationStatus)[PHPhotoLibrary authorizationStatus];
    }else {
        return (AuthorizationStatus)[ALAssetsLibrary authorizationStatus];
    }
}
+(void)requestAuthorization:(void (^)(AuthorizationStatus))handler {
    if (iOS8Upwards) {
        Block_exe(handler,(AuthorizationStatus)[PHPhotoLibrary authorizationStatus]);
    }else {
        Block_exe(handler,(AuthorizationStatus)[ALAssetsLibrary authorizationStatus]);
    }
}
@end
