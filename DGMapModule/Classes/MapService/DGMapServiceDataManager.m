//
//  DGMapServiceDataManager.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceDataManager.h"

@implementation DGMapServiceDataManager


- (NSString *)userCurrentCity {
    return self.userLocationPOI.city;
}



- (void)saveUserLocation:(CLLocationCoordinate2D)coordinate {
    _userLocationCoordinate = coordinate;
}


- (void)updateChooseLocation:(CLLocationCoordinate2D)coordinate {
    _choosedLocationCoordinate = coordinate;
}

@end
