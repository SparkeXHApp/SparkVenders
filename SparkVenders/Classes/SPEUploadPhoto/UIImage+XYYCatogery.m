//
//  UIImage+XYYCatogery.m
//  SparkBase
//
//  Created by apple on 2020/9/1.
//  Copyright © 2020 Spark. All rights reserved.
//

#import "UIImage+XYYCatogery.h"
#import <objc/runtime.h>

static char *ImageShowDeleteButtonKey = "ImageShowDeleteButtonKey";

@implementation UIImage (XYYCatogery)

- (BOOL)showDeleteButton {
    return [objc_getAssociatedObject(self, ImageShowDeleteButtonKey) boolValue];
}
- (void)setShowDeleteButton:(BOOL)showDeleteButton {
    objc_setAssociatedObject(self, ImageShowDeleteButtonKey, @(showDeleteButton), OBJC_ASSOCIATION_ASSIGN);
}

@end
