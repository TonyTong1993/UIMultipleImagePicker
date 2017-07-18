//
//  ViewController.m
//  UIMultipleImagePicker
//
//  Created by 童万华 on 2017/7/17.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "ViewController.h"
#import "ImageHandler.h"
#import "Config.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [ImageHandler requestAuthorization:^(AuthorizationStatus status) {
        
    }];
   ImageHandler *imageHandler = [[ImageHandler alloc] init];
   
    [imageHandler enumeratePHAssetCollectionsWithResultHandler:^(NSArray<PHAssetCollection *> *result) {
        for (PHAssetCollection *collection in result) {
           [imageHandler enumerateAssetsInGroup:collection finishBlock:^(NSArray *result) {
               LLog(@"result = %@",result);
           }];
        }
    }];
}
@end
