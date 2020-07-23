//
//  FontSizeView.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "FontSizeView.h"
#import "LTVideoProgressSlider.h"
@interface FontSizeView()

@property (nonatomic, strong) LTVideoProgressSlider          *slider;
@property (nonatomic, strong) UILabel                        *valueLb;
@property (nonatomic, strong) UIButton                       *back;

@end
@implementation FontSizeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorFromRGB(0xE1E1E6);
        
        self.back = [UIButton buttonWithType:UIButtonTypeCustom];
        self.back.showsTouchWhenHighlighted=YES;
        self.back.frame = CGRectMake(ScreenWidth - 60 - 15,15, 60, 30);
        [self.back setTitle:@"返回" forState:UIControlStateNormal];
        self.back.titleLabel.font = [UIFont systemFontOfSize:14.0];
        self.back.backgroundColor = [UIColor whiteColor];
        [self.back setTitleColor:JDC_MianColorBule forState:UIControlStateNormal];
        self.back.layer.borderColor = JDC_MianColorBule.CGColor;//颜色
        self.back.layer.borderWidth = 2.0f;//设置边框粗细
        [self.back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.back];
        
        int fontsize = 16;
        self.valueLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.back.frame)-90,20, 90, 20)];
        self.valueLb.textAlignment = NSTextAlignmentLeft;//靠左
        self.valueLb.text = [NSString stringWithFormat:@"%d%@",fontsize, @" <字号>"];
        self.valueLb.font = [UIFont systemFontOfSize:16.0];
        self.valueLb.textColor = [UIColor blackColor];
        [self addSubview:self.valueLb];
        
        
        self.slider = [[LTVideoProgressSlider alloc]initWithFrame:CGRectMake(15, 20, CGRectGetMinX(self.valueLb.frame) - 20 - 10, 20) direction:kLTSliderDirectionHorizontal];
        self.slider.minValue = 1;
        self.slider.maxValue = 50;
        self.slider.progressPercent = 0.3;
        self.slider.value = fontsize;
        self.slider.lineColor = [UIColor whiteColor];
        self.slider.progressLineColor = [UIColor whiteColor];
        self.slider.slidedLineColor = [UIColor redColor];
        self.slider.thumbTintColor = [UIColor blueColor];
        [self.slider addTarget:self action:@selector(action) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
    }
    return self;
}

- (void)action {
//    NSLog(@"%f/%f,progress:%f",self.slider.value,self.slider.maxValue,self.slider.progressPercent);
    self.valueLb.text = [NSString stringWithFormat:@"%d%@",(int)self.slider.value, @" <字号>"];
    if (self.delegete && [self.delegete respondsToSelector:@selector(FontSizeClick:)]) {
        [self.delegete FontSizeClick:(NSInteger)self.slider.value];
    }
   
}

- (void)backAction {
    if (self.delegete && [self.delegete respondsToSelector:@selector(FontSizeViewBtnClick)]) {
        [self.delegete FontSizeViewBtnClick];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
