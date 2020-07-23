//
//  BasicViewController.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/19.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>{
    UIStatusBarStyle  _barStyle;
}

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (@available(iOS 13.0, *)) {
        _barStyle = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? UIStatusBarStyleDarkContent :UIStatusBarStyleDefault;
    } else {
        // Fallback on earlier versions
    }
    // Do any additional setup after loading the view.
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    //判断是否是导航条的第一个子视图控制器
    if (self.navigationController && [self.navigationController.viewControllers count] >= 2) {
        return YES;
    }else{
        return NO;
    }
}
// 导航栏返回按钮
- (void)addNavBackBtn{
    [self addBackBtnWithImage:@"nav_back_black"];
}

- (void)addBackBtnWithImage:(NSString *)imageName{
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousButton addTarget:self action:@selector(navBackAction) forControlEvents:UIControlEventTouchUpInside];
    previousButton.frame = CGRectMake(0, 0, 30, 30);
    [previousButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [previousButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:previousButton];
    self.navigationItem.leftBarButtonItem = backItem;
}

// 导航栏点击返回事件
- (void)navBackAction{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 重置时间栏字体颜色
- (void)resetStatusBarStyle:(UIStatusBarStyle)style{
    _barStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return _barStyle;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
