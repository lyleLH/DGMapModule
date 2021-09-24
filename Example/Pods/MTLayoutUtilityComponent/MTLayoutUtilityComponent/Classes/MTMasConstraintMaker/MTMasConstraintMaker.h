//
//  MTMasConstraintMaker.h
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/3/12.
//

#import <Foundation/Foundation.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface MTMasConstraintMaker : NSObject

- (MTMasConstraintMaker * (^)(CGFloat))top;
- (MTMasConstraintMaker * (^)(CGFloat))topToBottom;
- (MTMasConstraintMaker * (^)(CGFloat))topToCenterY;
- (MTMasConstraintMaker * (^)(CGFloat))bottom;
- (MTMasConstraintMaker * (^)(CGFloat))bottomToTop;
- (MTMasConstraintMaker * (^)(CGFloat))bottomToCenterY;
- (MTMasConstraintMaker * (^)(CGFloat))left;
- (MTMasConstraintMaker * (^)(CGFloat))leftToRight;
- (MTMasConstraintMaker * (^)(CGFloat))leftToCenterX;
- (MTMasConstraintMaker * (^)(CGFloat))right;
- (MTMasConstraintMaker * (^)(CGFloat))rightToLeft;
- (MTMasConstraintMaker * (^)(CGFloat))rightToCenterX;
- (MTMasConstraintMaker * (^)(CGFloat))centerX;
- (MTMasConstraintMaker * (^)(CGFloat))centerY;

@end


@interface MASConstraintMaker (Extentions)
- (MTMasConstraintMaker * (^)(id))to;
@end


NS_ASSUME_NONNULL_END
