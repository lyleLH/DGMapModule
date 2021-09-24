//
//  MTLayout.m
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/6/11.
//

#import "MTLayout.h"

@implementation MTLayout

+ (CGFloat)mt_getFitWidth:(CGFloat)val {
    if ([UIScreen mt_isIphone6] || [UIScreen mt_isIphoneX] ) {
        return val;
    } else if ([UIScreen mt_isIphone5]  || [UIScreen mt_isIphone4OrEarlier]){
        return (int) (val*320.00/375.00);
    } else {
        return (int)(val*414.00/375.00);  //XR XSMAX PLUS 的width都为 414 pt
    }
}



+ (int)getFitHeight:(CGFloat)val {
    if([UIScreen mt_isIphone4OrEarlier]){
        return (int) (val*480.00/667.00);
    } else if ([UIScreen mt_isIphone5] ){
        return (int) (val*568.00/667.00);
    } else if ([UIScreen mt_isIphone6] ){
        return val;
    } else if ([UIScreen mt_isIphone6P] ){
        return (int) (val*736.00/667.00);
    } else if ([UIScreen mt_isIphoneX]){
        return (int) (val*(812.00-34.00)/667.00);
    } else if ([UIScreen mt_isIphoneXR]){
        return (int) (val*(896.00-34.00)/667.00);
    }else{
        return (int) (val*(896.00-34.00)/667.00);
    }
}

@end
