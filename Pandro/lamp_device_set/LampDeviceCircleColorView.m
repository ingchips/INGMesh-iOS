//
//  LampDeviceCircleColorView.m
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceCircleColorView.h"

@implementation LampDeviceCircleColorView

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
    
    self.image = [UIImage loadImageWithName:@"ic_color_full_521x512"];
    
    return self;
}


@end
