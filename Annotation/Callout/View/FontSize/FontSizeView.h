//
//  FontSizeView.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FontSizeViewDelegate <NSObject>

- (void)FontSizeViewBtnClick;
- (void)FontSizeClick:(NSInteger)fontSize;

@end
@interface FontSizeView : UIView
@property (nonatomic, weak) id <FontSizeViewDelegate>    delegete;
@end

NS_ASSUME_NONNULL_END
