//
//  PandroSliderView.m
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroSliderView.h"
#import "UIColor+PandroColor.h"

@implementation PandroSliderView

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
    self.backgroundColor = [UIColor littleGrayPandroColor];
    
    float height = 30;
    CGRect rect = CGRectMake(0, frame.size.height - height, frame.size.width, height);
    self.sliderView = [[UISlider alloc] initWithFrame:rect];
    [self addSubview:self.sliderView];

    self.sliderView.value = 0.5;
    self.sliderView.maximumTrackTintColor = [UIColor colorWithHexString:@"FFBFBFFF"];
    self.sliderView.minimumTrackTintColor = [UIColor colorWithHexString:@"FF3219FF"];

    [self.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    rect = CGRectMake(0, 0, 50, 20);
    self.sliderValueView = [[UILabel alloc] initWithFrame:rect];
    self.sliderValueView.backgroundColor = [UIColor clearColor];
    self.sliderValueView.font = [UIFont systemFontOfSize:18];
    self.sliderValueView.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
    [self addSubview:self.sliderValueView];
    self.sliderValueView.text = @"50%";
    
    [self sliderValueChanged:self.sliderView];
    
    return self;
}

-(void)sliderValueChanged:(UISlider *)slider
{
    self.sliderValueView.text = [NSString stringWithFormat:@"%d%%", (int)(self.sliderView.value * 100)];
    
    CGRect rect = self.sliderValueView.frame;
    rect.origin.x = self.sliderView.value * self.frame.size.width;
    if (rect.origin.x >= (self.sliderView.frame.size.width - 50))
    {
        rect.origin.x = self.sliderView.frame.size.width - 50;
    }
    self.sliderValueView.frame = rect;
}

@end
