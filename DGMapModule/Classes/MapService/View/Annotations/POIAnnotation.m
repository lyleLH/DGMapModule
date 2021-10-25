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

@property (nonatomic, readwrite, strong) NSString *initialTitle;
@property (nonatomic, readwrite, copy) NSString *address;

@end

@implementation POIAnnotation

@synthesize poi = _poi;
@synthesize tag = _tag;
#pragma mark - MAAnnotation Protocol



- (NSString *)title
{
    
    if(self.initialTitle) return self.initialTitle;
    return self.poi.name;
}

- (NSString *)subtitle
{
    if(self.address) return self.address;
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


- (id)initWithTitle:(NSString *)title andAddress:(NSString*)address {
    if (self = [super init])
    {
        _initialTitle = title;
        _address = address;
        
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
