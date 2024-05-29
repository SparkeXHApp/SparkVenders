//
//  SPEUploadPhotoView.h
//  SharePlatformExpert
//
//  Created by zhongjing on 2019/1/30.
//  Copyright © 2019 JARVIS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const addImageName = @"my添加图片";//添加照片名字，需要自定义

/**
 上传照片view
 */
@interface SPEUploadPhotoView : UIView
//图片数据源
@property(nonatomic,strong) NSMutableArray *imageDataSource;
//上传照片view高度更新回调
@property(nonatomic,copy) void (^ updateUploadPhotoViewHeightBlock)(CGFloat height);
//点击添加照片按钮回调
@property(nonatomic,copy) void (^ clickAddPhotoBlock)(BOOL isAddImageView, NSInteger index);
//最大上传照片张数
@property(nonatomic,assign) NSInteger maxCount;
//是否可以编辑
@property(nonatomic,assign) BOOL canEdit;
//是否存在删除按钮
@property(nonatomic,assign) BOOL canDelete;
//示列图片
@property(nonatomic,strong) UIImage *tagImage;

+ (instancetype)createUI;

/**
 刷新
 */
- (void)refresh;

/**
 设置添加图片最大张数限制
 
 @param count <#count description#>
 */
- (void)setUploadPhotoMaxCount:(NSInteger) count;

/**
 设置collectionViewCell列间距

 @param colSpace <#colSpace description#>
 */
- (void)setUploadPhotoItemColSpace:(CGFloat) colSpace;

/**
 设置collectionViewCell行间距

 @param rowSpace <#rowSpace description#>
 */
- (void)setUploadPhotoItemRowSpace:(CGFloat) rowSpace;

/**
 设置collectionView列数

 @param colCount <#colCount description#>
 */
- (void)setUploadPhotoColumnCount:(NSInteger) colCount;

@end

NS_ASSUME_NONNULL_END
