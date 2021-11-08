//
//  DGMapServiceDataManager.m
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import "DGMapServiceDataManager.h"

@implementation DGMapServiceDataManager

 - (DGMapLocationModel *)startLocationData {
    if(!_startLocationData){
         _startLocationData  = _userLocationData;
    }
     return _startLocationData;
 }

@end
