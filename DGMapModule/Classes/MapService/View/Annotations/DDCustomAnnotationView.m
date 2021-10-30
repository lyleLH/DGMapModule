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

#define kCalloutWidth   150
#define kCalloutHeight  70.0
//#define kCalloutHeight  44.0f

@interface DDCustomAnnotationView ()

@end

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
      
        self.calloutView = [[DDCustomCalloutView alloc] init];
        [self addSubview:self.calloutView];
        self.addressLabel = [[UILabel alloc] init];
        self.addressLabel.textColor = [UIColor mt_colorWithHex:0x4370F1];
        self.addressLabel.font = [UIFont boldSystemFontOfSize:12];
        self.addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.addressLabel.textAlignment = 0;
        self.addressLabel.numberOfLines = 2;
        
        [self addSubview:self.addressLabel];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /*坐标不合适再此设置即可*/
    //Code ...
//    CGFloat width =  [ self.calloutView.textLabel.text mt_widthByLimitHeight:35 font:[UIFont systemFontOfSize:15]];

    [self updateUIWithText];
    
}


- (void)updateUIWithText{
//    NSLog(@"-----> [calloutView width] : %.2f",width);
    if(!self.calloutView.hidden){
        CGSize size = [self.calloutView.textLabel.text boundingRectWithSize:CGSizeMake(kCalloutWidth, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:self.calloutView.textLabel.font}
                                                  context:nil].size;
        CGFloat height = size.height;
        if(size.height>kCalloutHeight){
            height = kCalloutHeight;
        }
     
        [self.calloutView setFrame:CGRectMake(0, 0, 10 + size.width  + 25, height+20 +10)];
        
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
     
    }else{
       
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 44, 44)];
        UIImage * image = self.imageView.image;
        CGSize imageSize = image.size;
        [self.imageView setFrame:CGRectMake((44-imageSize.width)*0.5, (44-imageSize.height)*0.5, imageSize.width, imageSize.height)];
        
        self.addressLabel.hidden = !self.calloutView.hidden;
        CGSize size = [self.calloutView.textLabel.text sizeWithAttributes:@{NSFontAttributeName:self.calloutView.textLabel.font}];
        [self.addressLabel setFrame:CGRectMake(CGRectGetMaxY(self.imageView.frame)+3, (44-size.height)*0.5, size.width, size.height)];
        self.addressLabel.text = self.calloutView.textLabel.text;
        
        
    }
 
}

@end
