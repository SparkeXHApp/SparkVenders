//
//  HWProgressView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWProgressView.h"
#import "UIColor+Progress.h"

@interface HWProgressView ()

@property (nonatomic, weak) UIView *tView;

@end

@implementation HWProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = UIColor.whiteColor;
        tView.layer.cornerRadius = self.bounds.size.height * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat maxWidth = self.bounds.size.width;
    CGFloat heigth = self.bounds.size.height;
    
    if (progress == 0) {
        _tView.frame = CGRectMake(0, 0, heigth, heigth);
    }else{
        _tView.frame = CGRectMake(0, 0, maxWidth * progress, heigth);
    }
}

-(void)setProgressColor:(NSString *)progressColor{
    if (_progress == 0) {
        self.tView.backgroundColor = [UIColor prColorWithHexString:@"C4CBDE"];
    }else{
        self.tView.backgroundColor = [UIColor prColorWithHexString:progressColor];
    }
}

@end

