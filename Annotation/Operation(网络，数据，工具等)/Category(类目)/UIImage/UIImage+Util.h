//
//  UIImage+Util.h
//  PDFPlay
//
//  Created by 许公子 on 2020/6/22.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Util)

+ (UIImage *)imageWithPureColor:(UIColor *)color;//纯颜色图片

+ (UIImage *)imageWithPureColor:(UIColor *)color withSize:(CGSize)size;

+ (UIImage *)QRCodeimageWithStr:(NSString *)codeStr withSize:(CGFloat)size;

+ (instancetype)waterMarkWithImage:(UIImage *)backgroundImage andMarkImageName:(NSString *)markName;

+ (UIImage *)gsImage:(UIImage *)cImage;

+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size;

+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size;

/// 给原图添加水印图片
/// @param imageView 水印图
/// @param cellHeight 显示的高度
- (UIImage *)imageWithWaterMask:(UIImageView *)imageView cellHeight:(float)cellHeight;
@end

NS_ASSUME_NONNULL_END
