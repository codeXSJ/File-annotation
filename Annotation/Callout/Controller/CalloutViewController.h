//
//  CalloutViewController.h
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalloutViewController : BasicViewController
@property (nonatomic, strong) NSURL              *fileUrl;     //PDF文件的url
@end

NS_ASSUME_NONNULL_END
