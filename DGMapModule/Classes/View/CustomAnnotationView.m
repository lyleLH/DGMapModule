//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

#import "UIImage+BundleImage.h"
#import <MTCategoryComponentHeader.h>
#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
//#define kCalloutHeight  70.0
#define kCalloutHeight  44.0f

@interface CustomAnnotationView ()
@property (nonatomic, strong) UIButton *addressButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSString *address;
@end

@implementation CustomAnnotationView

@synthesize calloutView;
 

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
    if(self.buttonAction){
        self.buttonAction();
    }
}

#pragma mark - Override

 
 
- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] init];
            
            [self.calloutView setFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.addressButton = btn;
            btn.frame = CGRectMake(kCalloutWidth- 40-10, 0, 40, kCalloutHeight);
            [btn setImage:[UIImage mt_imageWithName:@"icon_button_more_white" inBundle:@"DGMapModule"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.calloutView addSubview:btn];
            
            UILabel *name = [[UILabel alloc] init];
            [name setFrame :CGRectMake(10, 10, kCalloutWidth -50 -10, kCalloutHeight - 20)];
            self.nameLabel = name;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByCharWrapping;
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor whiteColor];
            name.font = [UIFont systemFontOfSize:14];
            name.text = _address;
            name.textAlignment = 1;
            [self.calloutView addSubview:name];
           
            CGFloat width =  [_address mt_widthByLimitHeight:35 font:[UIFont systemFontOfSize:15]];
            width +=20;
            width +=10;
            width +=40;
            [self updateUIWidth:width];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (void)updateContent:(NSString * )content {
    _address = content;
}


- (void)updateUIWidth:(CGFloat)width {
//    NSLog(@"-----> [calloutView width] : %.2f",width);
    [self.calloutView setFrame:CGRectMake(0, 0, width, kCalloutHeight)];
    self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                          -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
    self.addressButton.frame = CGRectMake(width- 40-10, 0, 40, kCalloutHeight);
    [self.nameLabel setFrame :CGRectMake(10, 10, width -50 -10, kCalloutHeight - 20)];
//    NSLog(@"-----> [calloutView frame] : %@",NSStringFromCGRect(self.calloutView.frame));
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
//        self.backgroundColor = [UIColor grayColor];
        
//         Create portrait image view and add to view hierarchy.
//        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
//        [self addSubview:self.portraitImageView];
//
//        /* Create name label. */
//        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
//                                                                   kVertMargin,
//                                                                   kWidth - kPortraitWidth - kHoriMargin,
//                                                                   kHeight - 2 * kVertMargin)];
//        self.nameLabel.backgroundColor  = [UIColor clearColor];
//        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
//        self.nameLabel.textColor        = [UIColor whiteColor];
//        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
//        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end
