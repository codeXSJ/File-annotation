//
//  BasicNavController.h
//  PDFPlay
//
//  Created by 许公子 on 2020/6/22.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JDCNavColor) {
    JDCNavColorWhite,
    JDCNavColorBlue,
};

@interface BasicNavController : UINavigationController
@property (nonatomic, assign)JDCNavColor   navColor;
@end

NS_ASSUME_NONNULL_END
