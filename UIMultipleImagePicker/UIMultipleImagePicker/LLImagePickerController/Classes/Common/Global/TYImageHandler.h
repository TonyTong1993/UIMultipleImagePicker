//
//  TYImageHandler.h
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
//访问相册授权状态
typedef NS_ENUM(NSInteger,TYAuthorizationStatus) {
    // 未确定授权
    TYAuthorizationStatusNotDetermined = 0,
    // 限制授权
    TYAuthorizationStatusRestricted,
    // 拒绝授权
    TYAuthorizationStatusDenied,
    // 已授权
    TYAuthorizationStatusAuthorized,
};
@interface TYImageHandler : NSObject
/** 获取相册授权状态
 * @brief 如果返回值为 LLAuthorizationStatusDenied | LLAuthorizationStatusDenied,
 *        则相册授权不成功, 不应进行下面的动作
 */
+ (TYAuthorizationStatus)requestAuthorization;

+ (void)requestAuthorization:(void(^)(TYAuthorizationStatus status))handler;

#pragma mark -
#pragma mark - 获取所有相册
/** 获取所有相册(iOS8及以下)
 * @brief result 的元素类型为 PHAssetCollection
 */
- (void)enumerateALAssetsGroupsWithResultHandler:(void(^)(NSArray <ALAssetsGroup *>*result))resultHandler NS_DEPRECATED_IOS(4_0, 9_0, "Use the enumeratePHAssetCollectionsWithResultHandler: instead");

/** 获取所有相册(iOS8及以上)
 * @brief result 的元素类型为 PHAssetCollection
 */
- (void)enumeratePHAssetCollectionsWithResultHandler:(void(^)(NSArray <PHAssetCollection *>*result))resultHandler NS_AVAILABLE_IOS(8_0);

/** 获取所有相册(兼容iOS8及iOS8)
 * @brief 如果iOS系统是8.0或以上, 则 result 的元素类型为 PHAssetCollection, 否则为 ALAssetsGroup
 */
- (void)enumerateGroupsWithFinishBlock:(void(^)(NSArray *result))finishBlock;


@end
@interface PHAssetCollection (LLAdd)

- (void)posterImage:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

- (void)posterImage:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

- (NSInteger)numberOfAssets;

@end

@interface PHAsset (LLAdd)

// 缩略图
- (void)thumbnail:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

- (void)thumbnail:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

// 原图
- (void)original:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

// 目标尺寸视图
- (void)requestImageForTargetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

- (void)originalSize:(void(^)(NSString *result))result;

@end
