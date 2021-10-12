//
//  POIAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "POIAnnotation.h"

@interface POIAnnotation ()

@property (nonatomic, readwrite, strong) AMapPOI *poi;
@property (nonatomic, readwrite, copy) NSString *tag;
@end

@implementation POIAnnotation

@synthesize poi = _poi;
@synthesize tag = _tag;
#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return self.poi.name;
}

- (NSString *)subtitle
{
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithPOI:(AMapPOI *)poi
{
    if (self = [super init])
    {
        self.poi = poi;
    }
    
    return self;
}

- (void)setTag:(NSString *)tag {
    _tag = tag;
}

-(NSString *)tag {
    return _tag;
}

@end
