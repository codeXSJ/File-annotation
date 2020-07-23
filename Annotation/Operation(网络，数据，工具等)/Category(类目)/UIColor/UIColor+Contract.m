//
//  UIColor+Contract.m
//  FileSynthesizer
//
//  Created by 许公子 on 2020/3/13.
//  Copyright © 2020 cc. All rights reserved.
//

#import "UIColor+Contract.h"

@interface NSString (UIColorContract)
- (NSString *)p_jdc_stringByTrim;
@end

@implementation NSString (UIColorContract)
- (NSString *)p_jdc_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}
@end

@implementation UIColor (Contract)

static inline NSUInteger jdc_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

static BOOL jdc_hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str p_jdc_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = jdc_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = jdc_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = jdc_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = jdc_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = jdc_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = jdc_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = jdc_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = jdc_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+ (instancetype)jdc_colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (jdc_hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}
@end
