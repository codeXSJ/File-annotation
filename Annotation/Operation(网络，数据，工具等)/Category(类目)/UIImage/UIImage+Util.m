//
//  UIImage+Util.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/22.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "UIImage+Util.h"

@implementation UIImage (Util)

// 生成指定大小的纯色图片
+ (UIImage *)imageWithPureColor:(UIColor *)color
{
    return [UIImage imageWithPureColor:color withSize:CGSizeMake(1, 1)];
}

// 生成指定大小的纯色图片
+ (UIImage *)imageWithPureColor:(UIColor *)color withSize:(CGSize)size
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(UIImage *)QRCodeimageWithStr:(NSString *)codeStr withSize:(CGFloat)size{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //过滤器恢复默认
    [filter setDefaults];
    
    //给过滤器添加数据
    NSString *string = codeStr;
    
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


+ (instancetype)waterMarkWithImage:(UIImage *)backgroundImage andMarkImageName:(NSString *)markName{
    
    UIImage *bgImage = backgroundImage;
    
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    UIImage *waterImage = [UIImage imageNamed:markName];
    CGFloat scale = 0.3;
    CGFloat margin = 5;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)gsImage:(UIImage *)cImage{
    //转换图片
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *midImage = [CIImage imageWithData:UIImagePNGRepresentation(cImage)];
    //图片开始处理
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:midImage forKey:kCIInputImageKey];
    //value 改变模糊效果值
    [filter setValue:@15.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outimage = [context createCGImage:result fromRect:[result extent]];
    //转换成UIimage
    UIImage *resultImage = [UIImage imageWithCGImage:outimage];
    
    return resultImage;
}

+ (UIImage *)resizeImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [image drawInRect:imageRect];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

// 生成条形码
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size{
    
    NSData *codeData = [code dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator" withInputParameters:@{@"inputMessage": codeData, @"inputQuietSpace": @.0}];
    return [self resizeCodeImage:filter.outputImage withSize:size];
}

+ (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    //! 将CIImage转成CGImageRef
    CGRect integralRect = image.extent;// CGRectIntegral(image.extent);// 将rect取整后返回，origin取舍，size取入
    CGImageRef imageRef = [[CIContext context] createCGImage:image fromRect:integralRect];
    
    //! 创建上下文
    CGFloat sideScale = fminf(size.width / integralRect.size.width, size.width / integralRect.size.height) * [UIScreen mainScreen].scale;// 计算需要缩放的比例
    size_t contextRefWidth = ceilf(integralRect.size.width * sideScale);
    size_t contextRefHeight = ceilf(integralRect.size.height * sideScale);
    CGContextRef contextRef = CGBitmapContextCreate(nil, contextRefWidth, contextRefHeight, 8, 0, CGColorSpaceCreateDeviceGray(), (CGBitmapInfo)kCGImageAlphaNone);// 灰度、不透明
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);// 设置上下文无插值
    CGContextScaleCTM(contextRef, sideScale, sideScale);// 设置上下文缩放
    CGContextDrawImage(contextRef, integralRect, imageRef);// 在上下文中的integralRect中绘制imageRef
    
    //! 从上下文中获取CGImageRef
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(contextRef);
    
    CGContextRelease(contextRef);
    CGImageRelease(imageRef);
    
    //! 将CGImageRefc转成UIImage
    UIImage *scaledImage = [UIImage imageWithCGImage:scaledImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    
    return scaledImage;
}

- (UIImage *)imageWithWaterMask:(UIImageView *)imageView cellHeight:(float)cellHeight{
    
    UIImage *image = imageView.image;
    CGRect rect = imageView.frame;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
     {
     UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
     }
    #else
     if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
     {
     UIGraphicsBeginImageContext([self size]);
     }
    #endif
     //原图
     [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
     //水印图
    [[UIColor clearColor] set];
    
     float x = self.size.width * rect.origin.x/ScreenWidth;
     float y = self.size.height * rect.origin.y/cellHeight;
     float w = self.size.width * rect.size.width/ScreenWidth;
     float h = self.size.height * rect.size.height/cellHeight;
     [image drawInRect:CGRectMake(x, y, w, h)];
     UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newPic;
}

@end
