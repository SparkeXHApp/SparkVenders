//
//  UNPhotoBrowser.m
//  ZhongQi
//
//  Created by lichen on 2018/7/27.
//  Copyright © 2018年 AntiqueDon. All rights reserved.
//

#import "UNPhotoBrowser.h"
#import "SDPhotoBrowser.h"

@interface UNPhotoBrowser()<SDPhotoBrowserDelegate>

@end

@implementation UNPhotoBrowser

- (void)show {
    SDPhotoBrowser * browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.sourceImagesContainerView;
    browser.imageCount = self.imageCount;
    browser.currentImageIndex = self.currentImageIndex;
    browser.delegate = self;
    [browser show];
}

#pragma mark - 代理方法

/**
 返回临时占位图片（即原来的小图）
 
 @param browser browser
 @param index 索引
 @return 源图
 */
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return self.srcImageArray[index];
}

/**
 返回高质量图片的url
 
 @param browser browser
 @param index 索引
 @return 高清图片url
 */
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    if (self.hightQualityImageArray.count < 1) {
        return nil;
    }
    NSString *urlStr = self.hightQualityImageArray[index];
    
    return [NSURL URLWithString:urlStr];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"photoBrowser is dealloc");
}

@end
