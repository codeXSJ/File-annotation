//
//  UIColor+Contract.h
//  FileSynthesizer
//
//  Created by 许公子 on 2020/3/13.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 Create UIColor with a hex string.
 Example: JDC_UIColorHex(0xF0F), JDC_UIColorHex(66ccff), JDC_UIColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef JDC_UIColorHex
#define JDC_UIColorHex(_hex_)   [UIColor jdc_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

//十六进制颜色
#define JDC_UIColorHex_Alpha(_hex_, a) [UIColor colorWithRed:((_hex_ >> 16) & 0x000000FF)/255.0f            \
                                                            green:((_hex_ >> 8) & 0x000000FF)/255.0f    \
                                                             blue:((_hex_) & 0x000000FF)/255.0f            \
                                                            alpha:a]
//RGBA颜色
#define JDC_UIColorRGBA(r,g,b,a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface UIColor (Contract)
/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)jdc_colorWithHexString:(NSString *)hexStr;
@end

NS_ASSUME_NONNULL_END
