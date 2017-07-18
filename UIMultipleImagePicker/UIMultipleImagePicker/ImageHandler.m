//
//  ImageHandler.m
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "ImageHandler.h"
#import "Config.h"
@interface ImageHandler()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, weak) PHPhotoLibrary *photoLibrary;
@property (nonatomic,strong) dispatch_queue_t currentQueue;

@end
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

-(instancetype)init {
    self = [super init];
    if (self) {
        if (iOS8Upwards) {
            self.photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
        }else {
            self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        }
        _currentQueue = dispatch_queue_create("lptiyu.com.UIMultipleImagePicker", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


#pragma mark -
#pragma mark - 获取所有相册

/**
  获取所有相册(iOS8及以下)

 @param resultHandler 回掉
 */
-(void)enumerateALAssetsGroupsWithResultHandler:(void (^)(NSArray<ALAssetsGroup *> *))resultHandler {
    NSMutableArray *groups = [NSMutableArray array];
     [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
         if ([group numberOfAssets]) {
             [groups addObject:group];
         }else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 Block_exe(resultHandler,groups);
             });
         }
     } failureBlock:^(NSError *error) {
         
     }];
}

/**
 获取所有相册(iOS8及以上)

 @param resultHandler 回掉
 */
-(void)enumeratePHAssetCollectionsWithResultHandler:(void (^)(NSArray<PHAssetCollection *> *))resultHandler {
  
    NSMutableArray *groups = [NSMutableArray array];
    dispatch_sync(self.currentQueue, ^{
        //系统相册
        PHFetchResult <PHAssetCollection *> *systemAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        //
        PHFetchResult <PHAssetCollection *> *customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        //过滤掉系统相册中无图片的相册
        for (PHAssetCollection *collection in systemAlbums) {
            
            if ([collection numberOfAssets] > 0) {
               
                [groups addObject:collection];
            }
        }
        //过滤掉用户相册中无图片的相册
        for (PHAssetCollection *collection in customAlbums) {
            
            if ([collection numberOfAssets] > 0) {
               
                [groups addObject:collection];
            }
        }
    });
    
    dispatch_sync(self.currentQueue, ^{
       dispatch_async(dispatch_get_main_queue(), ^{
           Block_exe(resultHandler,groups);
       });
    });
   
}

/**
 如果iOS系统是8.0或以上, 则 result 的元素类型为 PHAssetCollection, 否则为 ALAssetsGroup

 @param finishBlock 完成回掉
 */
-(void)enumerateGroupsWithFinishBlock:(void (^)(NSArray *))finishBlock {
    if (iOS8Upwards) {
        [self enumeratePHAssetCollectionsWithResultHandler:finishBlock];
    }else {
        [self enumerateALAssetsGroupsWithResultHandler:finishBlock];
    }
}

#pragma mark -
#pragma mark - 获取某一相册下所有图片资源

/**
  获取所有在assetCollection中的asset(兼容iOS8 及 iOS8)

 @param group 照片群组
 @param finishBlock 完成回掉
 */
-(void)enumerateAssetsInAssetsGroup:(ALAssetsGroup *)group finishBlock:(void (^)(NSArray <ALAsset *> *result))finishBlock {
    __block NSMutableArray *assets = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            //过滤图片
            if ([[result valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto]) {
                [assets addObject:result];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Block_exe(finishBlock,assets);
                });
            }
        }
    }];
}

/**
 获取所有在assetCollection中的asset(iOS8以上)

 @param collection 照片群组
 @param finishBlock 完成回掉
 */
-(void)enumerateAssetsInAssetCollection:(PHAssetCollection *)collection finishBlock:(void (^)(NSArray <PHAsset *> *result))finishBlock {
    NSMutableArray *results = [NSMutableArray array];
    dispatch_sync(self.currentQueue, ^{
        PHFetchResult <PHAsset *> *assets = [PHAsset fetchKeyAssetsInAssetCollection:collection options:nil];
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.mediaType == PHAssetMediaTypeImage) {
                [results addObject:obj];
            }
        }];
    });
    
    dispatch_sync(self.currentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            Block_exe(finishBlock,results);
        });
    });
}

/**
 获取所有在相册group中的assets (兼容iOS8 及 iOS8)

 @param group 相册
 @param finishBlock 完成回调
 */
- (void)enumerateAssetsInGroup:(id)group finishBlock:(void(^)(NSArray *result))finishBlock {
    if (!group) {
        return;
    }
    if ([group isKindOfClass:[PHAssetCollection class]]) {
        [self enumerateAssetsInAssetCollection:group finishBlock:finishBlock];
    } else if ([group isKindOfClass:[ALAssetsGroup class]]) {
        [self enumerateAssetsInAssetsGroup:group finishBlock:finishBlock];
    }
}
@end
@implementation PHAssetCollection (extention)

-(NSUInteger)numberOfAssets {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeImage];
    PHFetchResult <PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:self options:option];
    return result.count;
}

@end
