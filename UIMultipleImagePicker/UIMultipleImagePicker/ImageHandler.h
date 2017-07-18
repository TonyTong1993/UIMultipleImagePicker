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

#pragma mark -
#pragma mark - 获取某一相册下所有图片资源
/**
 获取所有在assetCollection中的asset(兼容iOS8 及 iOS8)
 
 @param group 照片群组
 @param finishBlock 完成回掉
 */
-(void)enumerateAssetsInAssetsGroup:(ALAssetsGroup *)group finishBlock:(void (^)(NSArray <ALAsset *> *result))finishBlock;

/**
 获取所有在assetCollection中的asset(iOS8以上)
 
 @param collection 照片群组
 @param finishBlock 完成回掉
 */
-(void)enumerateAssetsInAssetCollection:(PHAssetCollection *)collection finishBlock:(void (^)(NSArray <PHAsset *> *result))finishBlock;

/**
 获取所有在相册group中的assets (兼容iOS8 及 iOS8)
 
 @param group 相册
 @param finishBlock 完成回调
 */
- (void)enumerateAssetsInGroup:(id)group finishBlock:(void(^)(NSArray *result))finishBlock;

@end

@interface PHAssetCollection (extention)
-(NSUInteger)numberOfAssets;
@end
