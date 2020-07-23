//
//  BasicNavController.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/22.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "BasicNavController.h"

@interface BasicNavController ()

@end

@implementation BasicNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setNavColor:(JDCNavColor)navColor{
    _navColor = navColor;
    [self UpdateNavColor];
}
- (void)UpdateNavColor {
    
    switch (_navColor) {
        case JDCNavColorWhite:
            [self.navigationBar setBarTintColor:ColorFromRGB(0xffffff)];
            self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:ColorFromRGB(0x333333),
                                                       NSFontAttributeName:[UIFont systemFontOfSize:17]};
            break;
            
        default:
            break;
    }
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
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
