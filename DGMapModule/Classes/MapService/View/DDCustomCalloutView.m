//
//  DDCustomCalloutView.m
//  DingDing
//
//  Created by Dry on 2017/6/13.
//  Copyright © 2017年 ddtech. All rights reserved.
//

#import "DDCustomCalloutView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+BundleImage.h"
#import <MTCategoryComponent/MTCategoryComponentHeader.h>
#define kArrorHeight 10


@implementation DDCustomCalloutView


- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor mt_colorWithHex:0x06121E] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor mt_colorWithHex:0x06121E].CGColor);

    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 10.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
   
    
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


//- (void)drawRect:(CGRect)rect
//{
//    CGFloat width = rect.size.width;
//    CGFloat height = rect.size.height-kArrorHeight;
//    //圆角半径
//    CGFloat radius = (self.frame.size.height-kArrorHeight)*0.5;
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // 移动到初始点
//    CGContextMoveToPoint(context, radius, 0);
//    // 绘制第1条线和第1个1/4圆弧
//    CGContextAddLineToPoint(context, width - radius, 0);
//    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
//    // 绘制第2条线和第2个1/4圆弧
//    CGContextAddLineToPoint(context, width, height - radius);
//    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
//    // 绘制第3条线和第3个1/4圆弧
//    CGContextAddLineToPoint(context, radius, height);
//    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
//    // 绘制第4条线和第4个1/4圆弧
//    CGContextAddLineToPoint(context, 0, radius);
//    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
//    // 闭合路径
//    CGContextClosePath(context);
//    // 填充半透明黑色
//    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextDrawPath(context, kCGPathFill);
//
//    self.layer.shadowColor = [[UIColor grayColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
//}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setUpUI];
    }
    return self;
}

#pragma mark UI
- (void)setUpUI {
    self.textLabel = [[UILabel alloc]init];
//    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.textAlignment = 0;
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.numberOfLines = 0;
    [self addSubview:self.textLabel];
    
    self.rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.rightArrowButton setImage:[UIImage mt_imageWithName:@"icon_button_more_white" inBundle:@"DGMapModule"] forState:UIControlStateNormal];
    [self addSubview:self.rightArrowButton];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.rightArrowButton.frame = CGRectMake(self.frame.size.width- 25, 0, 25, self.frame.size.height- kArrorHeight);
    [self.textLabel setFrame:CGRectMake(10, 0, self.frame.size.width-25-10, self.frame.size.height   -kArrorHeight)];
}


@end
