//
//  PandroButton.m
//  Pandro
//
//  Created by chun on 2019/1/21.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroButton.h"
#import "UIImage+PandroImage.h"

@interface PandroButton ()



@end

@implementation PandroButton

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
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabe];
    
    [self addTarget:self action:@selector(clickSelf:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

-(id)initWithTitle:(NSString *)title image:(NSString *)image  frame:(CGRect)frame
{
    PandroButton *btn = [self initWithFrame:frame];
    
    btn.imageView.image = [UIImage loadImageWithName:image];
    btn.titleLabe.text = title;
    
    return btn;
}

-(void)clickSelf:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedPandroButton:)])
    {
        [self.delegate clickedPandroButton:self];
    }
}

#pragma mark getter and setter
-(UIImageView *)imageView
{
    if (!_imageView)
    {
        float width = ((2 *self.frame.size.height) / 3) - 5;
        CGRect rect = CGRectMake((self.frame.size.width - width)/2, 2, width, width);
        
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    
    return _imageView;
}

-(UILabel *)titleLabe
{
    if (!_titleLabe)
    {
        float height = self.frame.size.height/3;
        
        CGRect rect = CGRectMake(0,  (2 * self.frame.size.height) / 3 - 2, self.frame.size.width, height);
        _titleLabe = [[UILabel alloc] initWithFrame:rect];
        _titleLabe.backgroundColor = [UIColor clearColor];
        _titleLabe.font = [UIFont systemFontOfSize:height-3];
        _titleLabe.textColor = [UIColor whiteColor];
        _titleLabe.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabe;
}

@end
