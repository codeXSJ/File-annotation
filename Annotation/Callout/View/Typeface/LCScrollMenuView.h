//
//  LCScrollMenuView.h
//  LCScrollMenuViewDemo
//
//  Created by 冀柳冲 on 2017/6/28.
//  Copyright © 2017年 冀柳冲. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCScrollMenuView;

@protocol LCScrollViewDelegate <NSObject>

@optional
/**
 菜单按钮点击时回调
 
 @param scrollMenuView 带单view
 @param index 所点按钮的index
 */
- (void)scrollMenuView:(LCScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index;


@end




@interface LCScrollMenuView : UIScrollView

@property(nonatomic,assign) id<LCScrollViewDelegate>  menuDelegate;


/** 当前选择的按钮的index */
@property (nonatomic,assign) NSInteger currentButtonIndex;





/**
 初始化

 @param frame frame
 @param titles 标题数组
 @param font 字体大小
 @param schemeColor 主题背景色
 @param tintColor 字体颜色
 @param selectColor 被选中颜色
 @param lineColor 下划线颜色
 @return 对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                         font:(UIFont  *)font
              schemeColor:(UIColor *)schemeColor
                    tintColor:(UIColor *)tintColor
                  selectColor:(UIColor *)selectColor
                    lineColor:(UIColor *)lineColor
                        block:(void(^)(LCScrollMenuView *scrollView,NSInteger index))block;


@end
