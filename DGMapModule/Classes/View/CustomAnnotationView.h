//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

//@import UIKit;
//@import MAMapKit;

#import <UIKit/UIKit.h>
#import "MAMapKit.h"
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic,copy)dispatch_block_t buttonAction;
- (void)updateContent:(NSString * )content;
@end
