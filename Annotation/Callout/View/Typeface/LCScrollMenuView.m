//
//  LCScrollMenuView.m
//  LCScrollMenuViewDemo
//
//  Created by 冀柳冲 on 2017/6/28.
//  Copyright © 2017年 冀柳冲. All rights reserved.
//

#import "LCScrollMenuView.h"
#import "UIView+LCextra.h"


@interface LCScrollMenuView ()
{
    /** 用于记录最后创建的控件 */
    UIView *_lastView;
    /** 按钮下面的横线 */
    UIView *_lineView;
}

@property (nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) UIFont * font;
/**
 字体颜色
 */
@property(nonatomic,strong) UIColor  *tintColor;
/**
 被选中颜色
 */
@property(nonatomic,strong) UIColor  *selectedTintColor;

@property(nonatomic,strong) UIColor * schemeColor;
@property(nonatomic,strong) UIColor * lineColor;


@property(nonatomic,copy) void(^selectedBlock)(LCScrollMenuView *scrollView,NSInteger index);


@end

#define TintColor [UIColor blackColor]
#define SlectedColor [UIColor redColor]
#define LineColor [UIColor redColor]
#define NormalFont [UIFont systemFontOfSize:14]
#define SchemeColor [UIColor whiteColor];



@implementation LCScrollMenuView


/**
 初始化
 
 @param frame frame
 @param titles 标题数组
 @param font 字体大小
 @param schemeColor 主题背景色
 @param tintColor 字体颜色
 @param selectColor 被选中颜色
 @param lineColor 下划线颜色
 @return 对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                         font:(UIFont  *)font
                  schemeColor:(UIColor *)schemeColor
                    tintColor:(UIColor *)tintColor
                  selectColor:(UIColor *)selectColor
                    lineColor:(UIColor *)lineColor
                        block:(void(^)(LCScrollMenuView *scrollView,NSInteger index))block{
    
    
    self = [[LCScrollMenuView alloc]initWithFrame:frame];
    self.showsHorizontalScrollIndicator = NO;
    self.font = font;
    self.schemeColor = schemeColor ? schemeColor : SchemeColor;
    self.backgroundColor = schemeColor ? schemeColor : SchemeColor;
    self.tintColor = tintColor ? tintColor : TintColor;;
    self.selectedTintColor = selectColor ? selectColor : SlectedColor;
    self.lineColor = lineColor ? lineColor : LineColor;
    NSAssert(titles, @"titles is not allowed nil");
    [self setTitleArray:titles];
    
    //默认选中按钮
    _currentButtonIndex = 0;
    

    self.selectedBlock = ^(LCScrollMenuView *scrollView, NSInteger index) {
        if (block) {
            block(scrollView,index);
        }
    };
    
    
    return self;
    
}

#pragma mark - titleArray setter

-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    _lastView = nil;
    
    [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *menuButton = [[UIButton alloc]init];
        [self addSubview:menuButton];
        if (_lastView) {
            menuButton.frame = CGRectMake(_lastView.maxX + 10, 0, 100, self.height);
        }else{
            menuButton.frame = CGRectMake(10, 0, 100, self.height);
        }
        
        menuButton.tag = 100 + idx;
        [menuButton.titleLabel setFont:self.font];
        [menuButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [menuButton setTitleColor:self.selectedTintColor forState:UIControlStateSelected];
        [menuButton setTitle:obj forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 宽度自适应
        [menuButton sizeToFit];
        menuButton.height = self.height;
        
        // 这句不能少，不然初始化时button的label的宽度为0
        [menuButton layoutIfNeeded];
        
        // 默认第一个按钮时选中状态
        if (idx == 0) {
            menuButton.selected = YES;
            _lineView = [[UIView alloc]init];
            [self addSubview:_lineView];
            _lineView.bounds = CGRectMake(0, 0, menuButton.titleLabel.width, 2);
            _lineView.center = CGPointMake(menuButton.centerX, self.height - 1);
            _lineView.backgroundColor = self.lineColor;
        }
        
        _lastView = menuButton;
    }];
    
    self.contentSize = CGSizeMake(CGRectGetMaxX(_lastView.frame) + 10, self.height);
    
    // 如果内容总宽度不超过本身，平分各个模块
    if (_lastView.maxX < self.width) {
        int i = 0;
        for (UIButton *button in self.subviews) {
            if ([button isMemberOfClass:[UIButton class]]) {
                button.width = self.width / _titleArray.count;
                button.x = i * button.width;
                button.titleLabel.adjustsFontSizeToFitWidth = YES; // 开启，防极端情况
                if (i == 0) {
                    _lineView.width = button.titleLabel.width;
                    _lineView.centerX = button.centerX;
                    _lineView.maxY = self.height;
                }
                i ++;
            }
        }
    }
}
#pragma mark - 点击方法
- (void)menuButtonClicked:(UIButton *)sender{
    
    // 改变按钮的选中状态
    for (UIButton *button in self.subviews) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.selected = NO;
           // [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
        }
    }
    sender.selected = YES;
    //[sender.titleLabel setFont:[UIFont systemFontOfSize:16]];
    

    // 将所点击的button移到中间
    if (_lastView.maxX > self.width) {
        if (sender.x >= self.width / 2 && sender.centerX <= self.contentSize.width - self.width/2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(sender.centerX - self.width / 2, 0);
            }];
        }else if (sender.frame.origin.x < self.width / 2){
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(0, 0);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(self.contentSize.width - self.width, 0);
            }];
        }
    }
    
    // 改变下横线的位置和宽度
    [UIView animateWithDuration:0.3 animations:^{
        self->_lineView.width = sender.titleLabel.width;
        self->_lineView.centerX = sender.centerX;
    }];
    
    // 代理方执行方法
    if ([self.menuDelegate respondsToSelector:@selector(scrollMenuView:clickedButtonAtIndex:)]) {
        [self.menuDelegate scrollMenuView:self clickedButtonAtIndex:(sender.tag - 100)];
    }
    if (self.selectedBlock) {
        self.selectedBlock(self, sender.tag - 100);
    }
    

    
    
    //执行代理或者block
    
}

#pragma mark - 赋值当前选择的按钮
/** 赋值当前选择的按钮 */
- (void)setCurrentButtonIndex:(NSInteger)currentButtonIndex{
    _currentButtonIndex = currentButtonIndex;
    
    // 改变按钮的选中状态
    UIButton *currentButton = [self viewWithTag:(100 + currentButtonIndex)];
    for (UIButton *button in self.subviews) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.selected = NO;
        }
    }
    currentButton.selected = YES;
    
    // 将所点击的button移到中间
    if (_lastView.maxX > self.width) {
        if (currentButton.x >= self.width / 2 && currentButton.centerX <= self.contentSize.width - self.width/2) {
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(currentButton.centerX - self.width / 2, 0);
            }];
        }else if (currentButton.x < self.width / 2){
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(0, 0);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.contentOffset = CGPointMake(self.contentSize.width - self.width, 0);
            }];
        }
    }
    
    // 改变下横线的宽度和位置
    [UIView animateWithDuration:0.3 animations:^{
        self->_lineView.width = currentButton.titleLabel.width;
        self->_lineView.centerX = currentButton.centerX;
    }];
}


@end
