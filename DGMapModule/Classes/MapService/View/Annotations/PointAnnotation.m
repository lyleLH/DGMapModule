//
//  PointAnnotation.m
//  DGMapModule
//
//  Created by Tom on 2021/10/21.
//

#import "PointAnnotation.h"

@interface PointAnnotation ()
@property (nonatomic,copy) NSString * pointAddress;
@property (nonatomic,assign)CLLocationCoordinate2D location;

@end

@implementation PointAnnotation

@synthesize coordinate;

- (NSString *)title
{
    
    return self.pointAddress;
}

- (NSString *)subtitle
{
 
    return self.pointAddress;
}

- (CLLocationCoordinate2D)coordinate {
    return self.location;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _location = newCoordinate;
}


- (instancetype)initWithAddress:(NSString *)address andLocation:(CLLocationCoordinate2D)location {
    if (self = [super init]) {
        _pointAddress = address;
        _location = location;
    }
    
    return self;
}



@end
