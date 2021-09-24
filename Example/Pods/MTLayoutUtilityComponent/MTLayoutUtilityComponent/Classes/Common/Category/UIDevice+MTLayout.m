//
//  UIDevice+MTLayout.m
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/6/11.
//

#import "UIDevice+MTLayout.h"

@implementation UIDevice (MTLayout)
+ (BOOL)mt_deviceIsIphone {
    
    return  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
   
}

+ (BOOL)mt_iOS15OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0);
}


+ (BOOL)mt_iOS14OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0);
}

+ (BOOL)mt_iOS13OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0);
}

+ (BOOL)mt_iOS12OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0);
}


+ (BOOL)mt_iOS11OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0);
}

+ (BOOL)mt_iOS10OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0);
}

+ (BOOL)mt_iOS9OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0);
}

+ (BOOL)mt_iOS8OrLater {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);
}
 


@end
