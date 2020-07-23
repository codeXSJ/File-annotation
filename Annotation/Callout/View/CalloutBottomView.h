//
//  CalloutBottomView.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CalloutBottomViewDelegate <NSObject>

/// 创建
/// @param textView textView
/// @param delButton delButton
/// @param dragView dragView
/// @param countTag tag累加计数
/// @param typeface 字体
/// @param fontSize 字号
/// @param fontColor 文字颜色
- (void)A_CalloutBottomViewBtnClick:(UITextView *)textView
                          delButton:(UIButton *)delButton
                           dragView:(UIView *)dragView
                           countTag:(NSInteger)countTag
                           typeface:(NSString *)typeface
                           fontSize:(NSInteger)fontSize
                          fontColor:(UIColor *)fontColor
                          backColor:(UIColor *)backColor;
- (void)B_CalloutBottomViewBtnClick;
- (void)C_CalloutBottomViewBtnClick;
- (void)D_CalloutBottomViewBtnClick;
- (void)E_CalloutBottomViewBtnClick;

//textView拖动手势
- (void)textViewPanGuestre:(UIPanGestureRecognizer *)recognizer;
//dragView拖动手势
- (void)viewZoomPanGuestre:(UIPanGestureRecognizer *)recognizer;
//delButton删除事件
- (void)deleteEvents:(UIButton *)button;
//textView监听事件
- (void)monitorEvents:(UITextView *)textView;
//光标一开始的点击事件
- (void)textViewBeginEdit:(UITextView *)textView;


@end
@interface CalloutBottomView : UIView
@property (nonatomic, weak) id <CalloutBottomViewDelegate>    delegete;
@end

NS_ASSUME_NONNULL_END
