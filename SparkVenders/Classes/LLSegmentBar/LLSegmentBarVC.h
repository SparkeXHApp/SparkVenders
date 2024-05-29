//
//  LLSegmentBarVC.h
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSegmentBar.h"

@protocol LLSegmentBarVCDelegate <NSObject>

- (void)segmentBarVCToIndex: (NSInteger)toIndex;

@end

@interface LLSegmentBarVC : UIViewController

/**代理*/
@property (nonatomic,assign) id<LLSegmentBarVCDelegate> delegate;

@property (nonatomic,weak) LLSegmentBar * segmentBar;

- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;

@end
