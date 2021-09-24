//
//  UIScreen+MTLayout.m
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/6/11.
//

#import "UIScreen+MTLayout.h"
#import "UIDevice+MTLayout.h"

@implementation UIScreen (MTLayout)

+ (CGFloat)mt_screenWidth {
    return ([UIScreen mainScreen].bounds.size.width);
}

+ (CGFloat)mt_screenHeight {
    return ([UIScreen mainScreen].bounds.size.height);
}


+ (CGFloat)mt_maxLength {
    return MAX([self mt_screenWidth],[self mt_screenHeight]);
}

+ (CGFloat)mt_minLength {
    return MIN([self mt_screenWidth],[self mt_screenHeight]);
}


+ (BOOL)mt_isIphone4OrEarlier {
    return   [UIDevice mt_deviceIsIphone] &&[self mt_maxLength]<568.00;
}


+ (BOOL)mt_isIphone5 {
    return   [UIDevice mt_deviceIsIphone] &&[self mt_maxLength] == 568.00;
}

+ (BOOL)mt_isIphone6 {
    return   [UIDevice mt_deviceIsIphone] &&[self mt_maxLength] == 667.00;
}

+ (BOOL)mt_isIphone6P {
    return   [UIDevice mt_deviceIsIphone] &&[self mt_maxLength] == 736.00;
}

+ (BOOL)mt_isIphoneX {
    return   [UIDevice mt_deviceIsIphone] &&[self mt_maxLength] == 812.00;
}

+ (BOOL)mt_isIphoneXR {
    return   [UIDevice mt_deviceIsIphone] && ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)mt_isIphoneXsMax {
    return   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO);
}

//判断是否IPHONE_X后的机型全面屏带安全区域
+ (BOOL)mt_isIphoneXOrLater {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom>0.0;
    }
    return NO;
}

+ (CGFloat)mt_statusBarHeight {
    return [self mt_isIphoneXOrLater]?40:20;
}

//导航栏都是44，区别是状态栏高度不同
+ (CGFloat)mt_naviBarWithStatusBarHeight {
    return [self mt_isIphoneXOrLater]?88:64;
}

+ (CGFloat)mt_safeBottomMargin {
    return [self mt_isIphoneXOrLater]?34.0:0.0;
}

//34.0 + 49 = 83
+ (CGFloat)mt_tabbarHeight {
    return [self mt_isIphoneXOrLater]?83.0:49.0;
}

+ (CGFloat)mt_safeAreaHeight {
    return  ([self mt_naviBarWithStatusBarHeight]+[self mt_safeBottomMargin]);
}
 

+ (CGFloat)mt_itemInNaviBarOriginY {
    return  [self mt_isIphoneXOrLater]?24:0;
}


@end
