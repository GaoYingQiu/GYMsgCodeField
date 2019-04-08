//
//  PassWordView.m
//  GYMsgCodeFieldDemo
//
//  Created by qiugaoying on 2019/4/8.
//  Copyright © 2019年 qiugaoying. All rights reserved.
//

#import <Masonry.h>

#import "PassWordView.h"
@interface PassWordView ()<UITextFieldDelegate>{
    NSMutableArray *labelArray;
}
@end
@implementation PassWordView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self){
        self = [super initWithFrame:frame];
  
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.secureTextEntry = NO;
        labelArray = [NSMutableArray array];
        [self creatSub];
    }
    return self;
}


-(void)textViewEditChanged:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    if(textField == self.textF){

        NSUInteger maxLength = 6;
        NSString *contentText = textField.text;
        
        UITextRange *selectedRange = [textField markedTextRange];
        NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        if (markedTextLength == 0) {
            if (contentText.length > maxLength) {
                NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [contentText substringWithRange:rangeRange];
            }
        }
        
        
        NSString *textYZMStr = textField.text;
        NSInteger wordIndex = textYZMStr.length-1;
        
        //清空光标；
        for(NSInteger i = 0; i<labelArray.count; i++){
            UILabel *label = labelArray[i];
            UIView *keyLine = [label viewWithTag:1006];
            keyLine.hidden = YES;
        }
        
        if(wordIndex>=0){
            NSString *lastWord = [textYZMStr substringFromIndex:textYZMStr.length -1];
            UILabel *label = labelArray[wordIndex];
            label.text = self.secureTextEntry?@"●":lastWord;
            label.font = LJFontRegularText(self.secureTextEntry?13:19);
            
            //显示下一个光标；
            if(wordIndex+1< labelArray.count){
                UILabel *afterLabel = labelArray[wordIndex+1];
                UIView *keyLine = [afterLabel viewWithTag:1006];
                keyLine.hidden = NO;
            }
            
            //清空之后的数据；
            for (NSInteger index = wordIndex+1; index < labelArray.count; index ++) {
                UILabel *afterFindLabel = labelArray[index];
                afterFindLabel.text = @"";
            }
            
        }else{
            
            //全部清空label显示数据；
            for(NSInteger i = 0; i<labelArray.count; i++){
                UILabel *label = labelArray[i];
                label.text = @"";
            }
            
            UILabel *firstLabel = labelArray[0];
            UIView *keyLine = [firstLabel viewWithTag:1006];
            keyLine.hidden = NO;
        }
        
        //输入满6位 回调；
        if(self.pwdBlock){
            self.pwdBlock(self.contentString);
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSInteger totalCount = labelArray.count;
    NSInteger findKeyLineIndex = -1; //默认光标显示在第一个
    for (NSInteger i = totalCount-1; i>=0; i--) {
         UILabel *label = labelArray[i];
        if(label.text.length){
            findKeyLineIndex = i; //找到最后一个数字位置；
            break;
        }
    }
    
    findKeyLineIndex++; //后一个位置显示光标
    
    if(findKeyLineIndex< labelArray.count){
        UILabel *findKeyLabel = labelArray[findKeyLineIndex];
        UIView *keyLine = [findKeyLabel viewWithTag:1006];
        keyLine.hidden = NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //结束时需隐藏自定义光标 : 清空光标
    for(NSInteger i = 0; i<labelArray.count; i++){
        UILabel *label = labelArray[i];
        UIView *keyLine = [label viewWithTag:1006];
        keyLine.hidden = YES;
    }
}


-(void)creatSub{
    
    CGFloat labelWidth = 44 * (LJFontWidthScale>1?:1);
    CGFloat spaceMargin = (self.frame.size.width - labelWidth*6)/5.0; //5个间距
    
    for (int i = 0; i < 6; i ++){
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth *i + spaceMargin * i , 0, labelWidth, self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.layer.cornerRadius = 5;
        

        UIView *keyLineView = [[UIView alloc]init];
        keyLineView.backgroundColor = [UIColor orangeColor];
        keyLineView.tag = 1006;
        keyLineView.hidden = YES;
        [label addSubview:keyLineView];
        [keyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
            make.width.equalTo(@1.5);
        }];

        if(self.secureTextEntry){
            label.font = LJFontRegularText(13);
        }else{
            label.font = LJFontRegularText(19);
        }
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 1;
        [self addSubview:label];
        [labelArray addObject:label];
    }
    _textF = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _textF.delegate = self;
    _textF.textAlignment = NSTextAlignmentCenter;
    _textF.textColor = [UIColor clearColor];
    _textF.tintColor = [UIColor clearColor];
    _textF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self addSubview:_textF];
}


-(NSString *)contentString{
    
    if(self.secureTextEntry){
        
        return self.textF.text;
    }else{
        NSString *string = @"";
        for (UILabel *label in labelArray){
            string = [NSString stringWithFormat:@"%@%@",string,label.text];
        }
        return string;
    }
}

@end
