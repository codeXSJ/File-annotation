//
//  BackgroundColorView.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/17.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BackgroundColorViewDelegate <NSObject>

- (void)BackgroundColorViewBtnClick;
- (void)BackgroundColorClick:(UIButton *)btn;

@end
@interface BackgroundColorView : UIView
@property (nonatomic, weak) id <BackgroundColorViewDelegate>    delegete;
@end

NS_ASSUME_NONNULL_END
