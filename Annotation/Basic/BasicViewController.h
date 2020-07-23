//
//  BasicViewController.h
//  PDFPlay
//
//  Created by 许公子 on 2020/6/19.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicViewController : UIViewController
// 导航栏返回按钮
- (void)addNavBackBtn;

// 导航栏点击返回事件
- (void)navBackAction;

// 重置时间栏字体颜色(有的导航栏是白底黑字，有的是蓝底白字)
- (void)resetStatusBarStyle:(UIStatusBarStyle)style;
@end

NS_ASSUME_NONNULL_END
