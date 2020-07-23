//
//  Methods.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/23.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "Methods.h"

@implementation Methods
+ (BOOL)isNull:(id)object
{
   
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        
        if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@""]||[[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@"<null>"]||[[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual:@"(null)"]) {
            return NO;
        }
        else if (!object)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary * dic =object;
        if( [dic.allKeys count] ==0 ) {
            return NO;
            
        }
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        NSArray * ary =object;
        if( [ary count] ==0 ) {
            return NO;
            
        }
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    return YES;
}



+(UIImage *)getUIImageFromPDFPage: (CGPDFPageRef)pageRef
{
CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);

UIGraphicsBeginImageContext(pageRect.size);

CGContextRef imgContext = UIGraphicsGetCurrentContext();
CGContextSaveGState(imgContext);
CGContextTranslateCTM(imgContext, 0.0, pageRect.size.height);
CGContextScaleCTM(imgContext, 1.0, -1.0);
CGContextSetInterpolationQuality(imgContext, kCGInterpolationDefault);
CGContextSetRenderingIntent(imgContext, kCGRenderingIntentDefault);
CGContextDrawPDFPage(imgContext, pageRef);
CGContextRestoreGState(imgContext);
UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();

return tempImage;

}




+ (UIImage *)pq_WaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect cellHeight:(float)cellHeight{

    if([[UIScreen mainScreen] scale] == 2.0){                UIGraphicsBeginImageContextWithOptions(image.size, NO, 2.0);

    }
    else{
        UIGraphicsBeginImageContext(image.size);

    }
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
   
    [[UIColor whiteColor] set];
   
    float x = image.size.width * rect.origin.x/ScreenWidth;
    float y = image.size.height * rect.origin.y/cellHeight;
    float w = image.size.width * rect.size.width/ScreenWidth;
    float h = image.size.height * rect.size.height/cellHeight;
    [waterImage drawInRect:CGRectMake(x, y, w, h)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return newImage;
}


@end



