//
//  AssetMessageView.h
//  TimeBank
//
//  Created by 许公子 on 2020/3/16.
//  Copyright © 2020 JDC. All rights reserved.
//

/*
 消息弹窗（成功失败）
*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , JDCMessageStatus){
    JDCMessageSuccess = 0,
    JDCMessageFail,
    JDCMessageError,
};

@interface JDCMessageView : UIView

- (void)showMessageWithTitle:(NSString *)title andStatus:(JDCMessageStatus)status;

@end
