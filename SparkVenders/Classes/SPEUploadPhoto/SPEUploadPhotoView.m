//
//  SPEUploadPhotoView.m
//  SharePlatformExpert
//
//  Created by zhongjing on 2019/1/30.
//  Copyright © 2019 JARVIS. All rights reserved.
//

#import "SPEUploadPhotoView.h"
#import "SPEUploadPhotoCell.h"
#import "UIImage+XYYCatogery.h"
#import "UIImageView+WebCache.h"
#import "UNPhotoBrowser.h"

@interface SPEUploadPhotoView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//列间距
@property(nonatomic,assign) CGFloat itemColSpace;
//行间距
@property(nonatomic,assign) CGFloat itemRowSpace;
//列数
@property(nonatomic,assign) NSInteger columnCount;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstriant;
//数据源
@property(nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,strong) UNPhotoBrowser *photoBrowser;  //照片浏览

@end

@implementation SPEUploadPhotoView
- (void)awakeFromNib {
    [super awakeFromNib];
    //设置默认值
    self.itemColSpace = 10;
    self.itemRowSpace = 10;
    if ([self iPad]) {
        self.maxCount = 10;
        self.columnCount = 6;
    }else{
        self.maxCount = 3;
        self.columnCount = 3;
    }
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = self.itemRowSpace;//行间距
    layout.minimumInteritemSpacing = self.itemColSpace;//列间距
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SPEUploadPhoto" ofType:@"bundle"]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SPEUploadPhotoCell" bundle:resourceBundle] forCellWithReuseIdentifier:@"cell"];
    self.imageDataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self refresh];
}

/** 判断是不是iPad */
- (BOOL)iPad {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return true;
    }
    return false;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateViewHeight];
}

+ (instancetype)createUI {
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SPEUploadPhoto" ofType:@"bundle"]];
    return [[resourceBundle loadNibNamed:@"SPEUploadPhotoView" owner:self options:nil] firstObject];
}

- (void)setUploadPhotoMaxCount:(NSInteger)count {
    if (count < 1) return ;
    
    self.maxCount = count;
    [self.collectionView reloadData];
}
- (void)setUploadPhotoItemColSpace:(CGFloat)colSpace {
    if (colSpace < 0.0) return ;
    
    self.itemColSpace = colSpace;
    [self.collectionView reloadData];
}
- (void)setUploadPhotoItemRowSpace:(CGFloat)rowSpace {
    if (rowSpace < 0.0) return ;
    
    self.itemRowSpace = rowSpace;
    [self.collectionView reloadData];
}
- (void)setUploadPhotoColumnCount:(NSInteger)colCount {
    if (colCount < 1) return ;
    
    self.columnCount = colCount;
    [self.collectionView reloadData];
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    
    self.collectionView.userInteractionEnabled = canEdit;
}

-(void)setCanDelete:(BOOL)canDelete{
    _canDelete = canDelete;
}
#pragma mark - 刷新
- (void)refresh {
//    if (self.imageDataSource.count == 0) {
//        self.collectionViewHeightConstriant.constant = 0;
//        if (self.updateUploadPhotoViewHeightBlock) {
//            self.updateUploadPhotoViewHeightBlock(CGRectGetHeight(self.frame));
//        }
//        return ;
//    }
    id obj = [self.imageDataSource firstObject];
    
    if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        [self.dataSource removeAllObjects];
        [self.imageDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [self.dataSource addObject:obj];
            }
        }];
        [self updateViewHeight];
        [self.collectionView reloadData];
    } else {
        //UIImage
        [self.dataSource removeAllObjects];
        
        if (self.imageDataSource.count != self.maxCount) {
            [self.dataSource addObject:[UIImage imageNamed:addImageName]];
        }
        
        if (self.tagImage) {  //示例照片
            [self.dataSource addObject:self.tagImage];
        }
        
        [self.imageDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [self.dataSource insertObject:obj atIndex:0];
            }
        }];
        [self updateViewHeight];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SPEUploadPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.item >= self.dataSource.count) return cell;
    
    id obj = self.dataSource[indexPath.item];
    
    if ([obj isKindOfClass:NSClassFromString(@"UIImage")]) {
        UIImage *image = self.dataSource[indexPath.item];
        cell.imageView.image = image;
        cell.tagLabel.hidden = !(self.tagImage && indexPath.item == (self.dataSource.count - 1));  //示例图片
        
        cell.deleteButton.hidden = !image.showDeleteButton;  //展示删除按钮
    } else if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        NSString *url = self.dataSource[indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tupian"]];
    }
    
    if (_canDelete) {
        cell.deleteButton.hidden = YES;
    }
    __weak typeof(self) ws = self;
    cell.clickDeleteBlock = ^(SPEUploadPhotoCell * _Nonnull currentCell) {
        //点击删除按钮
        NSIndexPath *currentIndexPath = [ws.collectionView indexPathForCell:currentCell];
        NSInteger index = (ws.imageDataSource.count - 1) - currentIndexPath.item;
        if (ws.clickAddPhotoBlock) {
            ws.clickAddPhotoBlock(NO,index);
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.dataSource[indexPath.item];

    if ([obj isKindOfClass:NSClassFromString(@"UIImage")]) {
        if (self.maxCount == self.imageDataSource.count) {
            [self browserPhoto:obj indexPath:indexPath];
        } else {
            if (self.tagImage) {
                if (indexPath.item == (self.dataSource.count - 2)) {
                    //点击添加照片
                    if (self.clickAddPhotoBlock) {
                        self.clickAddPhotoBlock(YES, indexPath.item);
                    }
                } else {
//                    图片浏览
                    [self browserPhoto:obj indexPath:indexPath];
                }
            } else {
                if (indexPath.item == (self.dataSource.count - 1)) {
                    //点击添加照片
                    if (self.clickAddPhotoBlock) {
                        self.clickAddPhotoBlock(YES, indexPath.item);
                    }
                } else {
                    //图片浏览
                    [self browserPhoto:obj indexPath:indexPath];
                }
            }
        }
    } else if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        //图片浏览
        [self browserPhoto:obj indexPath:indexPath];
    }
}
#pragma mark - 浏览大图
- (void)browserPhoto:(id) obj indexPath:(NSIndexPath *) indexPath {
    SPEUploadPhotoCell *cell = (SPEUploadPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];

    if (!self.photoBrowser) {
        self.photoBrowser = [UNPhotoBrowser new];
        self.photoBrowser.imageCount = 1;
        self.photoBrowser.currentImageIndex = 0;
    }
    self.photoBrowser.sourceImagesContainerView = cell;
    //大图
    if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
        self.photoBrowser.hightQualityImageArray = [NSMutableArray arrayWithObject:obj];
        self.photoBrowser.srcImageArray = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"tupian"]];
    } else if ([obj isKindOfClass:NSClassFromString(@"UIImage")]) {
        self.photoBrowser.srcImageArray = [NSMutableArray arrayWithObject:obj];
    }
    [self.photoBrowser show];
}
- (void)updateViewHeight {
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat itemWidth = (width - self.itemColSpace * (self.columnCount - 1) * 1.0) / self.columnCount;//cell宽度
    CGFloat itemHeight = itemWidth;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
    layout.minimumLineSpacing = self.itemRowSpace;//行间距
    layout.minimumInteritemSpacing = self.itemColSpace;//列间距

    NSInteger count = self.dataSource.count;
    
    NSInteger row = count / self.columnCount + 1;//item行数
    if (count % self.columnCount == 0) {
        //偶数
        row = count / self.columnCount;
    }
    
    //添加的照片数 == maxCount，并且 maxCount % columnCount == 0，行数需要减1
    BOOL flag = (count - 1) == self.maxCount && ((count - 1) % self.columnCount == 0);
    if (flag) {
        row--;
    }
    
    CGFloat height = itemHeight * row + (row - 1) * self.itemRowSpace;//collectionView的高度
    
    self.collectionViewHeightConstriant.constant = height;
    
//    UNLog(@"%ld,%g,%g",count,height,CGRectGetHeight(self.frame));

    if (self.updateUploadPhotoViewHeightBlock) {
        self.updateUploadPhotoViewHeightBlock(CGRectGetHeight(self.frame));
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
@end
