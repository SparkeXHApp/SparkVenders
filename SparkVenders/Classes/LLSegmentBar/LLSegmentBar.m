//
//  LLSegmentBar.m
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import "LLSegmentBar.h"
#import "UIView+LLSegmentBar.h"

#define KMinMargin 30

@interface LLSegmentBar ()

/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
/** 指示器 */
@property (nonatomic, weak) UIImageView *indicatorView;

@property (nonatomic, strong) LLSegmentBarConfig *config;

@end

@implementation LLSegmentBar{
// 记录最后一次点击的按钮
    UIButton *_lastBtn;
}

+ (instancetype)segmentBarWithFrame:(CGRect)frame{
    LLSegmentBar *segmentBar = [[LLSegmentBar alloc]initWithFrame:frame];
    return segmentBar;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.sBBackColor;
    }
    return self;
}

- (void)updateWithConfig:(void (^)(LLSegmentBarConfig *))configBlock{
    if (configBlock) {
        configBlock(self.config);
    }
    // 按照当前的self.config 进行刷新
    self.backgroundColor = self.config.sBBackColor;
    self.indicatorView.backgroundColor = self.config.indicatorC;
    self.indicatorView.image = [UIImage imageNamed:@"NewUILineBar.png"];
    if(self.followType == -1){
        self.indicatorView.image = [UIImage imageNamed:@"滑块.png"];
    }
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.config.itemNC forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSC forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemF;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

-  (void)setSelectIndex:(NSInteger)selectIndex{
        
    if (self.items.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count- 1) {
        return;
    }
    
    
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}

- (void)setItems:(NSArray<NSString *> *)items{
    _items = items;
    // 删除之前添加过多的组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    
    // 根据所有的选项数据源 创建Button 添加到内容视图
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNC forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSC forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemF;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - private
- (void)btnClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:sender.tag fromIndex:_lastBtn.tag];
    }
    
    _selectIndex = sender.tag;
    
    _lastBtn.selected = NO;
    sender.selected = YES;
    _lastBtn = sender;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.width = 0 + self.config.indicatorW * 2;
        self.indicatorView.centerX = sender.centerX;
    }];

    // 滚动到Btn的位置
    CGFloat scrollX = sender.x - self.contentView.width * 0.5;
    
    // 考虑临界的位置
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.width) {
        scrollX = self.contentView.contentSize.width - self.contentView.width;
    }
    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    CGFloat totalBtnWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    CGFloat caculateMargin = (self.width - totalBtnWidth) / (self.items.count + 1);
    if (caculateMargin < KMinMargin) {
        caculateMargin = KMinMargin;
    }
    
    
    CGFloat lastX = caculateMargin;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
//       修改button下移5像素
        btn.y = 5;
        
        btn.x = lastX;
        
        lastX += btn.width + caculateMargin;
        if (self.followType == -1) {
            btn.y = 7;
        }
    }
    
    self.contentView.contentSize = CGSizeMake(lastX, 0);
    
    if (self.itemBtns.count == 0) {
        return;
    }
    
    UIButton *btn = self.itemBtns[self.selectIndex];
//    self.indicatorView.width = btn.width + self.config.indicatorW * 2;
    if (self.followType == -1) {
        self.indicatorView.width =  self.config.indicatorW * 2;
    }
    self.indicatorView.centerX = btn.centerX;
    self.indicatorView.height = self.config.indicatorH;
    self.indicatorView.y = self.height - self.indicatorView.height;
    if (self.followType == -1) {
        self.indicatorView.y = self.height - self.indicatorView.height - 2;
    }

}

#pragma mark - lazy-init


- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorH;
        UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorC;
        indicatorView.layer.cornerRadius=1.5;
        indicatorView.layer.masksToBounds=YES;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (LLSegmentBarConfig *)config{
    if (!_config) {
        _config = [LLSegmentBarConfig defaultConfig];
    }
    return _config;
}







@end
