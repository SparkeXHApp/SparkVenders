//
//  SPEUploadPhotoCell.h
//  SharePlatformExpert
//
//  Created by zhongjing on 2019/1/30.
//  Copyright © 2019 JARVIS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPEUploadPhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(nonatomic,copy) void (^ clickDeleteBlock)(SPEUploadPhotoCell *currentCell);

@end

NS_ASSUME_NONNULL_END
