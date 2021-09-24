//
//  MTMasConstraintMaker.m
//  MTLayoutUtilityComponent
//
//  Created by Tom.Liu on 2021/3/12.
//

#import "MTMasConstraintMaker.h"

 

@interface MTMasConstraintMaker ()
@property (nonatomic,strong) MASConstraintMaker *maker;
@property (nonatomic,strong) MAS_VIEW *obj;
@end

@implementation MTMasConstraintMaker


- (MTMasConstraintMaker *(^)(CGFloat))top {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.top.equalTo(self.obj).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))topToBottom {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.top.equalTo(self.obj.mas_bottom).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))topToCenterY {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.top.equalTo(self.obj.mas_centerY).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))bottom {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.bottom.equalTo(self.obj).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))bottomToTop {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.bottom.equalTo(self.obj.mas_top).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))bottomToCenterY {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.bottom.equalTo(self.obj.mas_centerY).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))left {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.left.equalTo(self.obj).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))leftToRight {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.left.equalTo(self.obj.mas_right).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))leftToCenterX {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.left.equalTo(self.obj.mas_centerX).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))right {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.right.equalTo(self.obj).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))rightToLeft {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.right.equalTo(self.obj.mas_left).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))rightToCenterX {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.right.equalTo(self.obj.mas_centerX).with.offset(-value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))centerY {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.centerY.equalTo(self.obj).with.offset(value);
        return self;
    };
}

- (MTMasConstraintMaker *(^)(CGFloat))centerX {
    return ^MTMasConstraintMaker * (CGFloat value) {
        self.maker.centerX.equalTo(self.obj).with.offset(value);
        return self;
    };
}

@end

@implementation MASConstraintMaker (Extentions)
- (MTMasConstraintMaker *(^)(id))to {
    
    return ^MTMasConstraintMaker * (id obj) {
        MTMasConstraintMaker *emaker = [MTMasConstraintMaker new];
        emaker.maker = self;
        emaker.obj = obj;
        return emaker;
    };
}

@end
