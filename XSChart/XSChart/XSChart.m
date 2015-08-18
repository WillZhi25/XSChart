//
//  Chart.m
//  ContractionCounter
//
//  Created by zhiwill on 15/2/17.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import "XSChart.h"

CGFloat margin=14.f;
CGFloat radius=5.f;
@interface XSChart ()
{
    NSMutableArray *_allLayer;
}
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) CAShapeLayer * linePath;
@property(nonatomic,assign)CGFloat avgHeight;
@property(nonatomic,assign)NSInteger maxValue;
@property(nonatomic,assign)NSInteger count;

@end
@implementation XSChart
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _linePath=[CAShapeLayer layer];
        _linePath.lineCap=kCALineCapRound;
        _linePath.lineJoin=kCALineJoinBevel;
        _linePath.lineWidth=2;
        _linePath.fillColor=[UIColor clearColor].CGColor;
        [self.layer addSublayer:_linePath];
        _maxValue=1;
        _allLayer=[NSMutableArray array];
    }
    return self;
}
-(NSInteger)maxValue
{
    for (int i=0; i<self.count; i++) {
        NSInteger value=[_dataSource chart:self valueAtIndex:i];
        _maxValue=value>_maxValue?value:_maxValue;
    }
    return _maxValue;
}
-(NSInteger)count
{
    return [_dataSource numberForChart:self];
}
-(CGFloat)avgHeight
{
    
    
    CGFloat height=self.frame.size.height;
    _avgHeight=(height-4*margin)/self.maxValue;
    return _avgHeight;
}
-(void)drawRect:(CGRect)rect
{
    [_allLayer enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperlayer];
    }];
    [_allLayer removeAllObjects];
    [self setupCoordinate];
    [self setupTitle];
    [self drawOriginAndMaxPoint];
    UIBezierPath *path=[UIBezierPath bezierPath];
    for (int i=0; i<self.count; i++) {
        CGFloat value=[_dataSource chart:self valueAtIndex:i];
        CGPoint point=[self pointWithValue:value index:i];
        if (i==0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle=kCGLineJoinRound;
    //path.lineWidth=1;
    [[UIColor redColor]setStroke];
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue=[NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses=NO;
    _linePath.path=path.CGPath;
    _linePath.strokeColor=[UIColor redColor].CGColor;
    [_linePath addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _linePath.strokeEnd = 1.0;
    
    for (int i=0; i<self.count; i++) {
        CGFloat value=[_dataSource chart:self valueAtIndex:i];
        CGPoint point=[self pointWithValue:value index:i];
        UIBezierPath *drawPoint=[UIBezierPath bezierPath];
        [drawPoint addArcWithCenter:point radius:radius startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
        CAShapeLayer *layer=[[CAShapeLayer alloc]init];
        layer.path=drawPoint.CGPath;
        _linePath.strokeEnd=1;
        [_allLayer addObject:layer];
        [self.layer addSublayer:layer];
        if (_dataSource&&[_dataSource respondsToSelector:@selector(showDataAtPointForChart:)]&&[_dataSource showDataAtPointForChart:self]) {
            NSString *valueString=[NSString stringWithFormat:@"%ld",(long)value];
            CGRect frame=[valueString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.f]} context:nil];
            CGPoint pointForValueString=CGPointMake(point.x-frame.size.width/2, point.y+margin/3);
            if (pointForValueString.y+frame.size.height>self.frame.size.height-1.5*margin) {
                pointForValueString.y=point.y-1.5*margin;
            }
            [valueString drawAtPoint:pointForValueString withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.f]}];
        }
        if (_dataSource&&[_dataSource respondsToSelector:@selector(chart:titleForXLabelAtIndex:)]) {
            NSString *titleForXLabel=[_dataSource chart:self titleForXLabelAtIndex:i];
            if (titleForXLabel) {
                [self drawXLabel:titleForXLabel index:i];
            }
        }
    }
    
}
-(void)drawXLabel:(NSString *)text index:(NSInteger)index
{//
    NSDictionary *font=@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    CGPoint point=[self pointWithValue:0 index:index];
    CGSize size=[text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:font context:nil].size;
    point.x-=size.width/2;
    point.y+=3;
    [text drawAtPoint:point withAttributes:font];
}
-(void)drawOriginAndMaxPoint
{
    NSDictionary *font=@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    
    NSString *origin=@"0";
    [origin drawAtPoint:CGPointMake(0.9*margin, self.frame.size.height-2*margin) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.f]}];
    
    NSString *max=[NSString stringWithFormat:@"%ld",(long)self.maxValue];
    CGRect tmpFrame=[max boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:font context:nil];
    [max drawAtPoint:CGPointMake(1.5*margin-tmpFrame.size.width-1, [self pointWithValue:_maxValue index:0].y-5) withAttributes:font];
}
-(void)setupTitle
{
    if (_dataSource&&[_dataSource respondsToSelector:@selector(titleForChart:)]) {
        self.titleLabel.text=[_dataSource titleForChart:self];
    }
    if (_dataSource&&[_dataSource respondsToSelector:@selector(titleForYAtChart:)]) {
        NSString *yTitle=[_dataSource titleForYAtChart:self];
        [yTitle drawAtPoint:CGPointMake(1.5*margin,0.5*margin) withAttributes:nil];
    }
    if (_dataSource&&[_dataSource respondsToSelector:@selector(titleForXAtChart:)]) {
        NSString *xTitle=[_dataSource titleForXAtChart:self];
        CGRect frame=[xTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]} context:nil];
        [xTitle drawAtPoint:CGPointMake(self.frame.size.width-margin-frame.size.width,self.frame.size.height-2*margin-frame.size.height) withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f]}];
    }
    
    
}
-(void)setupCoordinate
{
    UIBezierPath *coordinate=[UIBezierPath bezierPath];
    [coordinate moveToPoint:CGPointMake(1.5*margin, 1.5*margin)];
    [coordinate addLineToPoint:CGPointMake(1.5*margin, self.frame.size.height-1.5*margin)];
    [coordinate addLineToPoint:CGPointMake(self.frame.size.width-margin, self.frame.size.height-1.5*margin)];
    
    [coordinate stroke];
    
    UIBezierPath *arrowsForY=[UIBezierPath bezierPath];
    [arrowsForY moveToPoint:CGPointMake(margin, margin*2)];
    [arrowsForY addLineToPoint:CGPointMake(1.5*margin, 1.5*margin)];
    [arrowsForY addLineToPoint:CGPointMake(margin*2, margin*2)];
    [arrowsForY stroke];
    
    UIBezierPath *arrowsForX=[UIBezierPath bezierPath];
    [arrowsForX moveToPoint:CGPointMake(self.frame.size.width-(margin*1.5), self.frame.size.height-(margin*2))];
    [arrowsForX addLineToPoint:CGPointMake(self.frame.size.width-margin, self.frame.size.height-1.5*margin)];
    [arrowsForX addLineToPoint:CGPointMake(self.frame.size.width-(margin*1.5), self.frame.size.height-(margin*1))];
    [arrowsForX stroke];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    
    for (NSInteger i=0; i<self.count; i++) {
        NSInteger value=[_dataSource chart:self valueAtIndex:i];
        CGPoint point=[self pointWithValue:value index:i];
        if (CGRectContainsPoint(CGRectMake(point.x-radius, point.y-radius, radius*2, radius*2), [touch locationInView:self])) {
            if (_delegate&&[_delegate respondsToSelector:@selector(chart:didClickPointAtIndex:)]) {
                [_delegate chart:self didClickPointAtIndex:i];
            }
        }
    }
}
-(UILabel *)titleLabel
{
    if (_titleLabel==nil) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont systemFontOfSize:14.f];
        [self addSubview:_titleLabel];
        _titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_titleLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    }
    return _titleLabel;
  
}
-(CGPoint)pointWithValue:(NSInteger)value index:(NSInteger)index
{
    CGFloat height=self.frame.size.height;
    CGFloat width=self.frame.size.width;
    return  CGPointMake(2.5*margin+(width-2*margin)/self.count*index, height-value*self.avgHeight-1.5*margin);
}
-(void)reload
{
    [self setNeedsDisplay];
}
@end
