
//
//  PassWordView.h
//  GYMsgCodeFieldDemo
//
//  Created by qiugaoying on 2019/4/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//
#import <UIKit/UIKit.h>
#define SCREEN_W   [UIScreen mainScreen].bounds.size.width
#define SCREEN_H  [UIScreen mainScreen].bounds.size.height
#define LJFontWidthScale   ((CGFloat)((SCREEN_W < SCREEN_H ? SCREEN_W :SCREEN_H) / 375.0))
#define LJFontRegularText(fsize)  [UIFont fontWithName:@"PingFangSC-Regular" size:(fsize * LJFontWidthScale)]


@protocol SecretDelegate <NSObject>
- (void)secretValue:(NSString *)value;
@end

typedef void (^ConfirmPwdBlock)(NSString *pwdStr);

@interface PassWordView : UIView

@property (nonatomic,copy) ConfirmPwdBlock pwdBlock;
@property (nonatomic, assign) BOOL secureTextEntry;//是否是密码类型，默认YES
@property (nonatomic,strong)NSString *contentString;
@property (nonatomic,strong) UITextField *textF;

@property (nonatomic,weak) id<SecretDelegate>secretDelegate;

@end
