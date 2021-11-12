//
//  PandroProgressView.m
//  Pandro
//
//  Created by chun on 2019/3/7.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroProgressView.h"
#import "UIColor+PandroColor.h"

@implementation PandroProgressView

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
    float height = 2;
    CGRect rect = CGRectMake(0, (frame.size.height - height)/2, frame.size.width, height);
    self.progressView = [[UIProgressView alloc] initWithFrame:rect];
    [self addSubview:self.progressView];
    [self.progressView.layer setCornerRadius:2];
    [self.progressView.layer setMasksToBounds:YES];
    
    CGAffineTransform transfrom = CGAffineTransformMakeScale(1, 5);
    self.progressView.transform = transfrom;
    
    self.progressView.backgroundColor = [UIColor redColor];//colorWithHexString:@"FFBFBFFF"];
    self.progressView.tintColor = [UIColor colorWithHexString:@"FF3219FF"];
    self.progressView.progress = 0.5;
    
    return self;
}

@end
