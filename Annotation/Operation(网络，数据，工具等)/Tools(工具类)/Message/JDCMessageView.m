//
//  AssetMessageView.m
//  TimeBank
//
//  Created by 许公子 on 2020/3/16.
//  Copyright © 2020 JDC. All rights reserved.
//

#import "JDCMessageView.h"

@interface JDCMessageView()

@property (nonatomic, strong) UIButton                       * backBtn;
@property (nonatomic, strong) UIView                         * messageView;
@property (nonatomic, strong) UIImageView                    * tipImageView;
@property (nonatomic, strong) UIButton                       * closeBtn;
@property (nonatomic, strong) UILabel                        * titleLabel;

@end

@implementation JDCMessageView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@(0));
        }];
        
        [self addSubview:self.messageView];
        
        [self.messageView addSubview:self.tipImageView];
        [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.messageView);
            make.top.equalTo(@(30));
            make.height.width.equalTo(@(35));
        }];
        
        [self.messageView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-10));
            make.top.equalTo(@(10));
            make.width.height.equalTo(@(12.5));
        }];
        
        [self.messageView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(27));
            make.right.equalTo(@(-27));
            make.top.equalTo(self.tipImageView.mas_bottom).offset(10);
            make.height.equalTo(@(65));
        }];
    }
    return self;
}

#pragma mark - 响应事件

- (void)showMessageWithTitle:(NSString *)title andStatus:(JDCMessageStatus)status{
    _titleLabel.text = title;
    
    if(status == JDCMessageSuccess){
        _tipImageView.image = [UIImage imageNamed:@"asset_message_success"];
    }
    else if (status == JDCMessageFail){
        _tipImageView.image = [UIImage imageNamed:@"asset_message_fail"];
    }
    else if (status == JDCMessageError){
        _tipImageView.image = [UIImage imageNamed:@"asset_message_error"];
    }
    
    switch (status) {
        case JDCMessageSuccess:
        case JDCMessageFail:{
             _messageView.backgroundColor = [UIColor whiteColor];
            _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            _titleLabel.textColor = ColorFromRGB(0x333333);
            [_closeBtn setImage:[UIImage imageNamed:@"asset_message_close"] forState:0];
        }
            break;
            
        case JDCMessageError:{
             _messageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            _backBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.01];
            _titleLabel.textColor = [UIColor whiteColor];
            [_closeBtn setImage:[UIImage imageNamed:@"asset_message_error_close"] forState:0];
        }
            break;
            
        default:
            break;
    }
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.1;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(1.1);
    [self.messageView.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    WeakSelf(self);
    [UIView animateWithDuration:0.3 delay:0.f usingSpringWithDamping:0.42 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        StrongSelf(self);
        self.backBtn.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSelf{
    WeakSelf(self);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.2;
    scaleAnimation.repeatCount = 1;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(0.4);
    [self.messageView.layer addAnimation:scaleAnimation forKey:@"scale-layer"];
    
    [UIView animateWithDuration:0.2 animations:^{
        StrongSelf(self);
        self.messageView.alpha = self.backBtn.alpha = 0;
    } completion:^(BOOL finished) {
        StrongSelf(self);
        [self removeFromSuperview];
    }];
}

#pragma mark - 懒加载

-(UIButton *)backBtn{
    if(!_backBtn){
        _backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _backBtn.alpha = 0;
        [_backBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(UIView *)messageView{
    if(!_messageView){
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.573, 150)];
        _messageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        _messageView.backgroundColor = [UIColor whiteColor];
        _messageView.layer.cornerRadius = 10.0;
    }
    return _messageView;
}

-(UIImageView *)tipImageView{
    if(!_tipImageView){
        _tipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _tipImageView;
}

-(UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_closeBtn setImage:[UIImage imageNamed:@"asset_message_close"] forState:0];
        [_closeBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = ColorFromRGB(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end
