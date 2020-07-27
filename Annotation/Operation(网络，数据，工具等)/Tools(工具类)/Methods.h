//
//  Methods.h
//  PDFPlay
//
//  Created by 许公子 on 2020/6/23.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Methods : NSObject
+ (BOOL)isNull:(id)object;

+ (UIImage *)getUIImageFromPDFPage:(CGPDFPageRef)pageRef;

/// 添加水印
/// @param image 当前图片
/// @param waterImage 水印图片
/// @param rect 水印图片的rect
/// @param cellHeight cell的高度
+ (UIImage *)pq_WaterImageWithImage:(UIImage *)image
                         waterImage:(UIImage *)waterImage
                     waterImageRect:(CGRect)rect
                         cellHeight:(float)cellHeight;

@end

NS_ASSUME_NONNULL_END
