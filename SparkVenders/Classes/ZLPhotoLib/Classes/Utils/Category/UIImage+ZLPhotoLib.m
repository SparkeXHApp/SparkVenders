//
//  UIImage+ZLPhotoLib.m
//  MLCamera
//
//  Created by 张磊 on 15/4/25.
//  Copyright (c) 2015年 www.weibo.com/makezl All rights reserved.
//

#import "UIImage+ZLPhotoLib.h"

@implementation UIImage (ZLPhotoLib)
+ (instancetype)ml_imageFromBundleNamed:(NSString *)name{
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"ZLPhotoLib" ofType:@"bundle"]];
    return [UIImage imageNamed:[@"ZLPhotoLib.bundle" stringByAppendingPathComponent:[NSString stringWithFormat:@"zl_%@",name]] inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageFillSize:(CGSize)viewsize {
    CGSize size = self.size;
    
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    UIGraphicsBeginImageContext(viewsize);
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    
    CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}



// 缩放从顶部开始平铺图片
- (UIImage *)imageScaleAspectFillFromTop:(CGSize)frameSize {
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat radio = self.size.height / self.size.width;
    CGFloat height = frameSize.height / radio;
    // 缩放
    UIImage *adjustedImg = [self scaleToSize:CGSizeMake(frameSize.width * screenScale,
                                                        height)];
    // 裁剪
    adjustedImg = [adjustedImg subImageInRect:CGRectMake(0, 0, frameSize.width * screenScale,
                                                         frameSize.width * screenScale)];
    
    return adjustedImg;
}

-(UIImage*)subImageInRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CFRelease(subImageRef);
    
    return smallImage;
}


@end
