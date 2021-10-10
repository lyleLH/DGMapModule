//
//  DGMapServiceInteractor.h
//  MapService
//
//  Created by Tom.liu on 10/10/21.
//
//

#import <Foundation/Foundation.h>

#import "DGMapServicePresenter.h"
#import "DGMapServiceDataManager.h"

@class DGMapServicePresenter;

/**
 Business logic for the MapService module.
 */
@interface DGMapServiceInteractor : NSObject

@property (nonatomic, weak) DGMapServicePresenter *presenter;
@property (nonatomic, strong) DGMapServiceDataManager *dataManager;

@end
