//
//  Chart.h
//  ContractionCounter
//
//  Created by zhiwill on 15/2/17.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSChart;
@protocol XSChartDataSource <NSObject>
@required
-(NSInteger)numberForChart:(XSChart *)chart;
-(NSInteger)chart:(XSChart *)chart valueAtIndex:(NSInteger)index;
@optional
-(NSString *)titleForChart:(XSChart *)chart;
-(NSString *)titleForXAtChart:(XSChart *)chart;
-(NSString *)titleForYAtChart:(XSChart *)chart;
-(BOOL)showDataAtPointForChart:(XSChart *)chart;
-(NSString *)chart:(XSChart *)chart titleForXLabelAtIndex:(NSInteger)index;
@end
@protocol XSChartDelegate <NSObject>

@optional
-(void)chart:(XSChart *)view didClickPointAtIndex:(NSInteger)index;
@end

@interface XSChart : UIView
@property(nonatomic,assign)id<XSChartDataSource> dataSource;
@property(assign, nonatomic)id<XSChartDelegate> delegate;
-(void)reload;
@end
