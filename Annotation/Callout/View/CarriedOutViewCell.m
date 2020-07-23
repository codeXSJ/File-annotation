//
//  CarriedOutViewCell.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/29.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "CarriedOutViewCell.h"
@interface CarriedOutViewCell()

@property (nonatomic, strong) UIImageView                    *ImageView;

@end
@implementation CarriedOutViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _ImageView = [[UIImageView alloc]init];
    _ImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_ImageView];
    _ImageView.frame = self.frame;    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _ImageView.image = _image;
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    _ImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), _cellHeight);
}

- (void)setFrame:(CGRect)frame
{
    CGFloat margin = ScreenWidth;
    frame.size.width = margin;
    //阴影偏移效果 - wsx注释
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.shadowOpacity = 0.8f;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
