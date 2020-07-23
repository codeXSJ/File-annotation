//
//  CalloutBottomView.m
//  PDFPlay
//
//  Created by 许公子 on 2020/7/15.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "CalloutBottomView.h"
@interface CalloutBottomView()<UITextViewDelegate>{
    NSInteger countTag;
}

@property (nonatomic, strong) UILabel                        *label;
@property (nonatomic, strong) UIButton                       *button;
@property (nonatomic, strong) UIButton                       *delButton;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) UIView                         *dragView;

@end
@implementation CalloutBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CalloutBottomViewNot:) name:@"CalloutBottomView" object:nil];
        countTag = 0;
        self.backgroundColor = ColorFromRGB(0xE1E1E6);
        NSArray *imageArr = @[@"ic_t_sel",@"ic_zi_sel",@"ic_pencil_sel",@"ic_u_sel",@"ic_b_sel"];
        CGFloat interval = (ScreenWidth - 26*5)/6;
        for (int i = 0; i < imageArr.count; ++i) {
            self.button = [UIButton buttonWithType:UIButtonTypeCustom];
            self.button.tag = i;
            self.button.frame = CGRectMake(interval + (26 + interval) * i, 15, 26, 26);
            [self.button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.button];
            if (i == 0) {
                self.label = [[UILabel alloc]init];
                self.label.frame = CGRectMake(CGRectGetMaxX(self.button.frame), 15, interval, 26);
                self.label.text = @"+0";
                self.label.textColor = [UIColor redColor];
                [self addSubview:self.label];
            }
        }
    }
    return self;
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.tag == 0) {
        countTag++;
        _dragView = [[UIView alloc]init];
        _dragView.tag = DragView_Tag + countTag;
        _dragView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_moved_blue"]];
        _dragView.userInteractionEnabled = YES;
        [_dragView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ZoomPanGuestre:)]];
        
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _delButton.tag = DelButton_Tag + countTag;
        [_delButton setImage:[UIImage imageNamed:@"ic_cancel"] forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *typeface = @"PingFang SC";
        NSInteger fontSize = 16;
        UIColor *fontColor = [UIColor blackColor];
        UIColor *backColor = [UIColor clearColor];
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.font = [UIFont fontWithName:typeface size: fontSize];
        _textView.textColor = fontColor;
        _textView.backgroundColor = backColor;
        _textView.tag = Text_Tag + countTag;
        _textView.userInteractionEnabled = YES;
        _textView.multipleTouchEnabled = YES;
        [_textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
        //移动手势
        [_textView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGuestre:)]];
        
        
        //边框
        _textView.layer.borderColor = JDC_MianColorBule.CGColor;//颜色
        _textView.layer.borderWidth = 2.0f;//设置边框粗细
        _textView.layer.masksToBounds = YES;
           
        if (self.delegete && [self.delegete respondsToSelector:@selector(A_CalloutBottomViewBtnClick:delButton:dragView:countTag:typeface:fontSize:fontColor:backColor:)]) {
            [self.delegete A_CalloutBottomViewBtnClick:_textView delButton:_delButton dragView:_dragView countTag:countTag typeface:typeface fontSize:fontSize fontColor:fontColor backColor:backColor];
        }
    }
    if (btn.tag == 1) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(B_CalloutBottomViewBtnClick)]) {
            [self.delegete B_CalloutBottomViewBtnClick];
        }
    }
    if (btn.tag == 2) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(C_CalloutBottomViewBtnClick)]) {
            [self.delegete C_CalloutBottomViewBtnClick];
        }
    }
    if (btn.tag == 3) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(D_CalloutBottomViewBtnClick)]) {
            [self.delegete D_CalloutBottomViewBtnClick];
        }
    }
    if (btn.tag == 4) {
        if (self.delegete && [self.delegete respondsToSelector:@selector(E_CalloutBottomViewBtnClick)]) {
            [self.delegete E_CalloutBottomViewBtnClick];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"]) {
      [textView resignFirstResponder];
      return NO;
  }
  return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (self.delegete && [self.delegete respondsToSelector:@selector(textViewBeginEdit:)]) {
        [self.delegete textViewBeginEdit:textView];
    }
    return YES;
}

- (void)ZoomPanGuestre:(UIPanGestureRecognizer *)recognizer {
    if (self.delegete && [self.delegete respondsToSelector:@selector(viewZoomPanGuestre:)]) {
        [self.delegete viewZoomPanGuestre:recognizer];
    }
}

- (void)handlePanGuestre:(UIPanGestureRecognizer *)recognizer {
    if (self.delegete && [self.delegete respondsToSelector:@selector(textViewPanGuestre:)]) {
        [self.delegete textViewPanGuestre:recognizer];
    }
}

- (void)deleteAction:(UIButton *)btn {
    if (self.delegete && [self.delegete respondsToSelector:@selector(deleteEvents:)]) {
        [self.delegete deleteEvents:btn];
    }
}


- (void)textViewDidChange:(UITextView *)textView { // 在该代理方法中实现实时监听uitextview的输入
    if (self.delegete && [self.delegete respondsToSelector:@selector(monitorEvents:)]) {
        [self.delegete monitorEvents:textView];
    }
}

#pragma mark - 通知

- (void)CalloutBottomViewNot:(NSNotification *)notifi{
    self.label.text = [NSString stringWithFormat:@"%@%@",@"+",notifi.userInfo.allValues[0]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
