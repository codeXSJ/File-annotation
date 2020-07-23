//
//  UITextView+UIScreenDisplaying.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/21.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "UITextView+UIScreenDisplaying.h"

@implementation UITextView (UIScreenDisplaying)
// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)isShowingOnKeyWindow
{
 //主窗口
 UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  
 //以窗口的左上角为坐标原点，计算self的矩形框
 CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];
 CGRect windowBounds = keyWindow.bounds;
 //判断newFrame是不是在windowBounds上
 BOOL isOnWindow = CGRectIntersectsRect(newFrame, windowBounds);
 
 return self.window == keyWindow && !self.hidden && self.alpha > 0.01 && isOnWindow;
 }
@end
