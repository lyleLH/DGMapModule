//
//  DDCustomAnnotationView.m
//  DingDing
//
//  Created by Dry on 2017/6/13.
//  Copyright © 2017年 ddtech. All rights reserved.
//

#import "DDCustomAnnotationView.h"
#import <MTCategoryComponentHeader.h>
//#define kCalloutWidth       120.0
//#define kCalloutHeight      45.0

#define kCalloutWidth   200.0
//#define kCalloutHeight  70.0
#define kCalloutHeight  44.0f

@implementation DDCustomAnnotationView

//复写父类init方法
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        //创建大头针视图
        [self setUpClloutView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (selected)
    {
        [self setUpClloutView];
    }
    else
    {
    }
    [super setSelected:selected animated:animated];
}

- (void)setUpClloutView {
    if (self.calloutView == nil)
    {
        self.calloutView = [[DDCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        [self addSubview:self.calloutView];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*坐标不合适再此设置即可*/
    //Code ...
//    CGFloat width =  [ self.calloutView.textLabel.text mt_widthByLimitHeight:35 font:[UIFont systemFontOfSize:15]];
    
    CGSize size = [self.calloutView.textLabel.text sizeWithAttributes:@{NSFontAttributeName:self.calloutView.textLabel.font}];

  
    [self updateUIWidth:size.width];
    
}


- (void)updateUIWidth:(CGFloat)width {
//    NSLog(@"-----> [calloutView width] : %.2f",width);
    [self.calloutView setFrame:CGRectMake(0, 0, width + 20+25, kCalloutHeight)];
    
    self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                          -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
 
//    NSLog(@"-----> [calloutView frame] : %@",NSStringFromCGRect(self.calloutView.frame));
}

@end