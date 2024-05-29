//
//  UNPhotoBrowser.h
//  ZhongQi
//
//  Created by lichen on 2018/7/27.
//  Copyright © 2018年 AntiqueDon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 照片浏览
 */
@interface UNPhotoBrowser : NSObject
/** 源图片的父控件*/
@property (nullable,nonatomic, weak) UIView *sourceImagesContainerView;

/** 当前需要展示图片的index*/
@property (nonatomic, assign) NSInteger currentImageIndex;

/** 原图的数量*/
@property (nonatomic, assign) NSInteger imageCount;

/** 数据源：原图片数组*/
@property(nonatomic,retain) NSMutableArray<UIImage *> * srcImageArray;

/** 数据源：高清图片的url*/
@property(nonatomic,retain) NSMutableArray<NSString *> * hightQualityImageArray;

/**
 展示
 */
- (void)show;

@end
