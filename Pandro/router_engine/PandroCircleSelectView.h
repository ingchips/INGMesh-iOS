//
//  PandroCircleSelectView.h
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PandroCircleSelectView;

@protocol PandroCircleSelectViewProtocol <NSObject>

-(void)touchEndThenCompute:(PandroCircleSelectView *)circleView;

@end

@interface PandroCircleSelectView : UIImageView

@property(nonatomic, strong)id<PandroCircleSelectViewProtocol> circleDelegate;

@property(nonatomic, strong)UIImageView *selectedView;

-(UIColor *)computeSelectedColorFromPoint;
-(float)computeSelectedLengthToCenter;

@end

