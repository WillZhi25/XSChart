//
//  FPCircleView.m
//  Tool
//
//  Created by 植梧培 on 15/8/17.
//  Copyright (c) 2015年 植梧培. All rights reserved.
//

#import "XSCircleView.h"
@interface XSCircleView ()
@property (nonatomic, strong) UILabel *titleLabel;


@end


@implementation XSCircleView


- (void)drawRect:(CGRect)rect {
    if (self.lineWidth == 0) {
        self.lineWidth = 5;
    }
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = width / 2;
    
    UIBezierPath *currentPath = [UIBezierPath bezierPath];
    [_currentColor setStroke];
    [currentPath addArcWithCenter:CGPointMake(width / 2, height / 2) radius:self.bounds.size.width / 2 startAngle:0 endAngle:M_PI * _percent * 2 clockwise:YES];
    currentPath.lineWidth = self.lineWidth;
    [currentPath stroke];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [_color setStroke];
    [path addArcWithCenter:CGPointMake(width / 2, height / 2) radius:self.bounds.size.width / 2 startAngle:M_PI * _percent * 2 endAngle: M_PI * 2 clockwise:YES];
    path.lineWidth = self.lineWidth;
    [path stroke];

}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLabel.font = _font;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|"
                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|"
                                                                     options:NSLayoutFormatAlignAllCenterX
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_titleLabel)]];
    }
    return _titleLabel;
}


- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.titleLabel.textColor = _textColor;
}

@end
