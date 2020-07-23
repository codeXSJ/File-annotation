//
//  UILabel+Util.m
//  PDFPlay
//
//  Created by 许公子 on 2020/6/23.
//  Copyright © 2020 xsj. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)
+ (void)labHeigth:(UILabel *)lab labX:(float)Sx labY:(float)Sy imaHeigth:(float)imaH {
    //根据内容计算出label所需要的高度

      CGSize size = CGSizeMake(ScreenWidth-Sx*2, MAXFLOAT);

      NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:lab.font,NSFontAttributeName,nil];

      CGSize  actualsize =[lab.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;

     lab.frame =CGRectMake(Sx, Sy, ScreenWidth-Sx*2, actualsize.height+imaH);
}
@end
