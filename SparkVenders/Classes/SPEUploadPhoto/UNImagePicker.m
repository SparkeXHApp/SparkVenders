//
//  UNImagePicker.m
//  TrunkPartsMall
//
//  Created by lichen on 2018/4/13.
//  Copyright © 2018年 重友科技. All rights reserved.
//

#import "UNImagePicker.h"
#import <TZImagePickerController/TZImagePickerController.h>
#define UIColorRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UNImagePicker()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,copy) UNImagePickerHandler completion;
@property(nonatomic,copy) void (^ imagePickerHandler)(UIImage * image);

@property(nonatomic,strong) UIImagePickerController *imagePicker;

@end

@implementation UNImagePicker

- (UIViewController *)imagePickerWithMaxImageCount:(NSInteger)maxImageCount completion:(UNImagePickerHandler)completion {
    
    self.completion = completion;
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImageCount delegate:self];
    imagePicker.alwaysEnableDoneBtn = NO;
    imagePicker.allowPickingOriginalPhoto = NO;
    imagePicker.allowPickingVideo = NO;
    imagePicker.allowPickingGif = NO;
    imagePicker.barItemTextColor = UIColorRGB(0x4c84ff);
    imagePicker.naviTitleColor = UIColorRGB(0x4c84ff);
    
    return imagePicker;
}

- (UIViewController *)imagePickerFromCameraWithCompletion:(void (^)(UIImage *))completion {
    self.imagePickerHandler = completion;
    return self.imagePicker;
}
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    if (self.completion) {
//        self.completion(photos, assets, isSelectOriginalPhoto);
//    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
//    NSLog(@"infos = %@",infos);
    if (self.completion) {
        self.completion(photos, assets, isSelectOriginalPhoto,infos);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //处理一下图片，否则内存会暴涨
    UIImage *image = [self processImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    if (self.imagePickerHandler) {
        self.imagePickerHandler(image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 处理图片
- (UIImage *)processImage:(UIImage *) sourceImage {
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

#pragma mark - 懒加载
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [UIImagePickerController new];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.allowsEditing = NO;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
@end
