//
//  LampDeviceCircleTemperatureView.m
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceCircleTemperatureView.h"

@implementation LampDeviceCircleTemperatureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.image = [UIImage loadImageWithName:@"warm_cold_circle_512x512_"];
    
    return self;
}


@end
