//
//  DGMapLocationModel.m
//  DGMapModule
//
//  Created by Tom on 2021/10/24.
//

#import "DGMapLocationModel.h"

@implementation DGMapLocationModel

- (instancetype)initWithLocation:(CLLocationCoordinate2D )location {
    if(self ==[super init]){
        _location = location;
    }
    return self;
}




- (void)fillWtihRegeoResponse:(AMapReGeocodeSearchResponse *)response {
    self.regeocode = response.regeocode;
    if(response.regeocode.pois.count>0){
        NSInteger minIndex = [self compareDistanceWithPois:response.regeocode.pois];
        self.poi = response.regeocode.pois[minIndex];
        NSMutableArray * result = [response.regeocode.pois mutableCopy] ;
        [result removeObjectAtIndex:minIndex];
        self.aroundPois = [NSArray arrayWithArray:result];
    }
}
//比较距离 人后将大头针设到最近的POI点

- (NSInteger)compareDistanceWithPois:(NSArray  <AMapPOI *> *)pois {
    MAMapPoint centerPoint =  MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude));
    NSMutableArray <NSNumber *>*distances = [NSMutableArray new];
    for (NSInteger i =0; i <pois.count; i ++) {
        AMapPOI * poi = pois[i];
        MAMapPoint point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude));
        CLLocationDistance distance = MAMetersBetweenMapPoints(centerPoint,point);
        [distances addObject:[NSNumber numberWithDouble:distance]];
    }
    
    double xmax = -MAXFLOAT;
    double xmin = MAXFLOAT;
    for (NSNumber *num in distances) {
        double x = num.doubleValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    NSNumber * minNumber = [NSNumber numberWithDouble:xmin];
    
    NSInteger minIndex = 0;
    for (NSInteger i =0 ; i <distances.count; i ++) {
        if([minNumber isEqualToNumber:distances[i]]){
            minIndex = i;
            break;
        }
    }
    return minIndex;
}


@end
