//
//  CarriedOutViewCell.h
//  PDFPlay
//
//  Created by 许公子 on 2020/6/29.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarriedOutViewCell : UITableViewCell
@property (nonatomic, strong) UIImage                   *image;
@property (nonatomic, assign) CGFloat                    cellHeight;//每页PDF的高度
@end

NS_ASSUME_NONNULL_END
