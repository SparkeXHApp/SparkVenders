//
//  SPEUploadPhotoCell.m
//  SharePlatformExpert
//
//  Created by zhongjing on 2019/1/30.
//  Copyright © 2019 JARVIS. All rights reserved.
//

#import "SPEUploadPhotoCell.h"

@implementation SPEUploadPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 点击删除按钮
- (IBAction)clickDeleteAction:(UIButton *)sender {
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock(self);
    }
}

@end
