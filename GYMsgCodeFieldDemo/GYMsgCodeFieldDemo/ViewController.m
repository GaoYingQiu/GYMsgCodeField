//
//  ViewController.m
//  GYMsgCodeFieldDemo
//
//  Created by qiugaoying on 2019/4/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//
#import <Masonry.h>
#import "ViewController.h"
#import "PassWordView.h"

@interface ViewController ()

@property (nonatomic , strong) PassWordView *secView;
@property (nonatomic , strong) NSString * yzmSecStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GYMsgCodeField";
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    _secView = [[PassWordView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W - 60, 44)];
    _secView.secureTextEntry = NO;
    _secView.pwdBlock = ^(NSString *pwdStr) {
        weakSelf.yzmSecStr = pwdStr;
        
        BOOL blRulesFlag = YES; //判断是否满足业务其他条件，则收回键盘；
        if(blRulesFlag && weakSelf.yzmSecStr.length == 6){
            [weakSelf.view endEditing:YES];
        }
        //业务处理；....
    };
    [self.view addSubview:_secView];
    [_secView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(150);
        make.right.mas_equalTo(-30);
        make.height.equalTo(@44);
        make.bottom.mas_equalTo(0);
    }];
    
    
    UILabel *label =  [[UILabel alloc]init];
    label.font = LJFontRegularText(17);
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"是否密码框：%@",(self.secView.secureTextEntry?@"是":@"否")];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.equalTo(self.secView.mas_top).offset(-50);
    }];
}


@end
