//
//  UIScreen+MTLayout.h
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/6/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (MTLayout)


+ (CGFloat)mt_screenWidth;

+ (CGFloat)mt_screenHeight;

+ (CGFloat)mt_maxLength;

+ (CGFloat)mt_minLength;


+ (BOOL)mt_isIphone4OrEarlier ;


+ (BOOL)mt_isIphone5;

+ (BOOL)mt_isIphone6;

+ (BOOL)mt_isIphone6P;

+ (BOOL)mt_isIphoneX ;

+ (BOOL)mt_isIphoneXR;

+ (BOOL)mt_isIphoneXsMax ;

//判断是否IPHONE_X后的机型全面屏带安全区域
+ (BOOL)mt_isIphoneXOrLater ;

+ (CGFloat)mt_statusBarHeight;

//导航栏都是44，区别是状态栏高度不同
+ (CGFloat)mt_naviBarWithStatusBarHeight;

+ (CGFloat)mt_safeBottomMargin;
//34.0 + 49 = 83
+ (CGFloat)mt_tabbarHeight;

+ (CGFloat)mt_safeAreaHeight;
 

+ (CGFloat)mt_itemInNaviBarOriginY;

@end

NS_ASSUME_NONNULL_END
