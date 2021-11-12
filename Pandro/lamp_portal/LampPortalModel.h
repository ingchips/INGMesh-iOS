//
//  LampPortalModel.h
//  Pandro
//
//  Created by chun on 2019/1/18.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshPlaceModel.h"

@interface LampPortalModel : NSObject

@property(nonatomic)BOOL allDevice;
@property(nonatomic)BOOL expand;

@property(nonatomic, strong)MeshPlaceModel *placeModel;

@end

