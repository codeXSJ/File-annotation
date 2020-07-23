//
//  FontColorView.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/16.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FontColorViewDelegate <NSObject>

- (void)FontColorViewBtnClick;
- (void)FontColorClick:(UIButton *)btn;

@end
@interface FontColorView : UIView
@property (nonatomic, weak) id <FontColorViewDelegate>    delegete;
@end

NS_ASSUME_NONNULL_END
