//
//  MTViewController.m
//  DGMapModule
//
//  Created by Tom.Liu on 09/10/2021.
//  Copyright (c) 2021 Tom.Liu. All rights reserved.
//

#import "MTViewController.h"
#import <DGMapModule/DGMapModuleHeader.h>
@interface MTViewController ()

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    DGMapViewManager *manager = [[DGMapViewManager alloc] init];
    [self.view addSubview:manager.mapView];
    [manager.mapView setFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height - 400)];
}
 









@end
