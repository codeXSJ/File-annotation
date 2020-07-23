//
//  MBProgressHUD+ShowInWindow.m
//  FileSynthesizer
//
//  Created by 许公子 on 2020/3/19.
//  Copyright © 2020 jidecai. All rights reserved.
//

#import "MBProgressHUD+ShowInWindow.h"
#import "MBProgressHUD+MJ.h"
@implementation MBProgressHUD (ShowInWindow)
+(void)showLoading {
    [MBProgressHUD showMessage:@"正在加载"];
}
@end
