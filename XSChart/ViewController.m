//
//  ViewController.m
//  XSChart
//
//  Created by zhiwill on 15/3/2.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import "ViewController.h"
#import "XSChart.h"
@interface ViewController ()<XSChartDataSource,XSChartDelegate>
@property(nonatomic,strong)NSArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _data=@[@1,@2,@3,@4,@9,@6,@12];
    XSChart *chart=[[XSChart alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 250)];
    chart.dataSource=self;
    chart.delegate=self;
    [self.view addSubview:chart];
   
}
-(NSInteger)numberForChart:(XSChart *)chart
{
    return _data.count;
}
-(NSInteger)chart:(XSChart *)chart valueAtIndex:(NSInteger)index
{
    return [_data[index] floatValue];
}
-(BOOL)showDataAtPointForChart:(XSChart *)chart
{
    return YES;
}
-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"%ld",(long)index];
}
-(NSString *)titleForChart:(XSChart *)chart
{
    return @"XSChart Demo";
}
-(NSString *)titleForXAtChart:(XSChart *)chart
{
    return @"Index";
}
-(NSString *)titleForYAtChart:(XSChart *)chart
{
    return @"count";
}
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index
{
    NSLog(@"click at index:%ld",(long)index);
}
@end
