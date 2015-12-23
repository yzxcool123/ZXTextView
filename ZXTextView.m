//
//  ZXTextView.m
//
//
//  Created by YeZhongxiang on 15-12-23.
//  Copyright (c) 2014年 macbook. All rights reserved.
//

#import "ZXTextView.h"

@interface ZXTextView() <UITextViewDelegate>

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation ZXTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupPlaceholderView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupPlaceholderView];
    }
    return self;
}

- (void)setupPlaceholderView {
    self.backgroundColor = [UIColor clearColor];
    
    // 添加一个显示提醒文字的label（显示占位文字的label）
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.numberZXLines = 0;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
    // 设置默认的占位文字颜色
    self.placeholderColor = [UIColor lightGrayColor];
    
    // 设置默认的字体
    self.font = [UIFont systemFontZXSize:14];
    
    // 监听内部文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变 

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}

#pragma mark - 公共方法

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    // 设置文字
    self.placeholderLabel.text = placeholder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    // 设置颜色
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.y = 8;
    self.placeholderLabel.x = 5;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
    CGSize placeholderSize = [self.placeholder sizeWithFont:self.placeholderLabel.font constrainedToSize:maxSize];
    self.placeholderLabel.height = placeholderSize.height;
}

@end
