//
//  TypefaceView.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "TypefaceView.h"
#import "LCScrollMenuView.h"
@interface TypefaceView ()<LCScrollViewDelegate>

@property(nonatomic,strong) LCScrollMenuView    *menuView;
@property(nonatomic,strong) UIButton            *back;
@end
@implementation TypefaceView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorFromRGB(0xE1E1E6);
        
        self.back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.back.showsTouchWhenHighlighted=YES;
        self.back.frame = CGRectMake(ScreenWidth - 60 - 15,12, 60, 30);
        [self.back setTitle:@"返回" forState:UIControlStateNormal];
        self.back.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.back.backgroundColor = [UIColor whiteColor];
        [self.back setTitleColor:JDC_MianColorBule forState:UIControlStateNormal];
        self.back.layer.borderColor = JDC_MianColorBule.CGColor;//颜色
        self.back.layer.borderWidth = 2.0f;//设置边框粗细
        [self.back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.back];
        
        
        NSArray *typefaceArr = @[@"PingFang SC",@"Thonburi",@"Georgia",@"Kailasa",@"Damascus",@"Noteworthy",@"Avenir",@"Mishafi",@"Futura",@"Farah",@"Arial",@"Chalkduster",@"Optima",@"Palatino",@"Helvetica",@"Courier",@"Cochin",@"Verdana",@"Baskerville",@"Symbol",@"Menlo",@"Papyrus"];
        self.menuView = [[LCScrollMenuView alloc]initWithFrame:CGRectMake(15, 10, CGRectGetMinX(self.back.frame)-15-10, 36) titles:typefaceArr font:[UIFont systemFontOfSize:14] schemeColor:[UIColor whiteColor] tintColor:[UIColor blackColor] selectColor:[UIColor redColor] lineColor:[UIColor redColor] block:^(LCScrollMenuView *scrollView, NSInteger index) {
            if (self.delegete && [self.delegete respondsToSelector:@selector(TypefaceClick:)]) {
                [self.delegete TypefaceClick:typefaceArr[index]];
            }
        }];
        self.menuView.menuDelegate = self;
        //当前控制器是作为navigationController的子控制器，自然会有一个导航栏，而系统会自动使导航栏下面的第一个scrollview的contentOffset.y值下移64个点，就是导航栏的height。
        //如果存在导航栏,应执行下面这句
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [self addSubview:self.menuView];
    }
    return self;
}

- (void)backAction {
    if (self.delegete && [self.delegete respondsToSelector:@selector(TypefaceViewBtnClick)]) {
        [self.delegete TypefaceViewBtnClick];
    }
}

//#pragma mark - delegate
//-(void)scrollMenuView:(LCScrollMenuView *)scrollMenuView clickedButtonAtIndex:(NSInteger)index{
//    NSLog(@"index = %ld",index);
//    
//    switch (index) {
//        case 0:
//        {
//            
//        }
//            break;
//        case 1:
//        {
//            
//        }
//            break;
//        case 2:
//        {
//            
//        }
//            break;
//        case 3:
//        {
//            
//        }
//            break;
//        case 4:
//        {
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
