//
//  MTLayout.h
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/6/11.
//

#import <Foundation/Foundation.h>
#import "MTLayoutCategoryheader.h"
NS_ASSUME_NONNULL_BEGIN

@interface MTLayout : NSObject
+ (CGFloat)mt_getFitWidth:(CGFloat)val;
+ (CGFloat)getFitHeight:(CGFloat)val ;

@end

NS_ASSUME_NONNULL_END
