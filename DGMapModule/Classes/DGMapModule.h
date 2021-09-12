//
//  DGMapModule.h
//  DGMapModule
//
//  Created by Tom.Liu on 2021/9/10.
//

#import <Foundation/Foundation.h>
#import "DGMapModuleServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN



@interface DGMapModule : NSObject <DGMapModuleServiceInterface>
@property (nonatomic,weak)id <DGMapModuleServiceDelegate> mapServiceDelegate;
@end

NS_ASSUME_NONNULL_END
