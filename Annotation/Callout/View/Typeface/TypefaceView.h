//
//  TypefaceView.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TypefaceViewDelegate <NSObject>

- (void)TypefaceViewBtnClick;
- (void)TypefaceClick:(NSString *)colorStr;

@end
@interface TypefaceView : UIView
@property (nonatomic, weak) id <TypefaceViewDelegate>    delegete;
@end

NS_ASSUME_NONNULL_END
