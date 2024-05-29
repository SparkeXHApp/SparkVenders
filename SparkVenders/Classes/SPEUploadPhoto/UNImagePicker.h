//
//  UNImagePicker.h
//  TrunkPartsMall
//
//  Created by lichen on 2018/4/13.
//  Copyright © 2018年 重友科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ UNImagePickerHandler) (NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos);

/**
 照片选择
 */
@interface UNImagePicker : NSObject

/**
 从相册选择照片

 @param maxImageCount 最大张数
 @param completion 完成回调
 @return <#return value description#>
 */
- (UIViewController *)imagePickerWithMaxImageCount:(NSInteger) maxImageCount completion:(UNImagePickerHandler) completion;

/**
 从相机获取照片

 @param completion 完成回调
 @return <#return value description#>
 */
- (UIViewController *)imagePickerFromCameraWithCompletion:(void(^)(UIImage *image)) completion;

@end
