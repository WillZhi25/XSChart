//
//  FPCircleView.h
//  Tool
//
//  Created by 植梧培 on 15/8/17.
//  Copyright (c) 2015年 植梧培. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSCircleView : UIView
@property (nonatomic, strong) IBInspectable UIColor *currentColor;
@property (nonatomic, strong) IBInspectable UIColor *color;
@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, assign) IBInspectable CGFloat percent;//value 0 to 1.0
@property (nonatomic, assign) IBInspectable NSInteger lineWidth;//default 5
@property (nonatomic, strong) UIFont *font;

@end
