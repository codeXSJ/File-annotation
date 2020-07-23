//
//  BackgroundColorView.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/17.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "BackgroundColorView.h"
@interface BackgroundColorView ()

@property(nonatomic,strong) UIButton            *back;
@property(nonatomic,strong) UIButton            *colorBtn;
@property(nonatomic,strong) NSMutableArray      *buttonArr;
@end
@implementation BackgroundColorView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorFromRGB(0xE1E1E6);
        self.buttonArr = [[NSMutableArray alloc]init];
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
        
        NSArray *colorArr = @[[UIColor clearColor],[UIColor whiteColor],[UIColor redColor],MainBlueColor,[UIColor brownColor],[UIColor greenColor],[UIColor cyanColor],[UIColor blueColor],[UIColor blackColor]];
        CGFloat interval = (ScreenWidth - 15*2-60-10-26*colorArr.count)/8;
        for (int i = 0; i < colorArr.count; ++i) {
            self.colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.colorBtn.tag = i;
            self.colorBtn.frame = CGRectMake(15 + (26 + interval) * i, 15, 26, 26);
            self.colorBtn.layer.borderWidth = 2.0f;//设置边框粗细
            self.colorBtn.backgroundColor = colorArr[i];
            [self.colorBtn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                self.colorBtn.layer.borderColor = [UIColor orangeColor].CGColor;//颜色
            } else {
                self.colorBtn.layer.borderColor = [UIColor purpleColor].CGColor;//颜色
            }
            [self addSubview:self.colorBtn];
            [self.buttonArr addObject:self.colorBtn];
        }
        
    }
    return self;
}

- (void)backAction {
    if (self.delegete && [self.delegete respondsToSelector:@selector(BackgroundColorViewBtnClick)]) {
        [self.delegete BackgroundColorViewBtnClick];
    }
}

- (void)colorBtnAction:(UIButton *)btn {
    for (UIButton *button in self.buttonArr) {
        if (button.tag == btn.tag) {
            button.layer.borderColor = [UIColor orangeColor].CGColor;//颜色
        } else {
            button.layer.borderColor = [UIColor purpleColor].CGColor;//颜色
        }
    }
    if (self.delegete && [self.delegete respondsToSelector:@selector(BackgroundColorClick:)]) {
        [self.delegete BackgroundColorClick:btn];
    }
}
@end
