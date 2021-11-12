//
//  PandroCircleSelectView.m
//  Pandro
//
//  Created by chun on 2019/1/22.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "PandroCircleSelectView.h"
#import "UIImage+PandroImage.h"

@interface PandroCircleSelectView ()

@property(nonatomic)CGPoint movedPoint;

@end




@implementation PandroCircleSelectView

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
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.selectedView];
    self.selectedView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    return self;
}

-(void)dealloc
{
    
}

#pragma mark init
-(void)initRawData:(UIImage *)image
{
    float xx, yy;
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char* rawData = (unsigned char*)calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    unsigned long byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
    
}

#pragma mark fun
-(void)moveSelectedViewPoint:(CGPoint )center
{
    //check length
    float length = (center.x  - self.frame.size.width/2 ) * (center.x  - self.frame.size.width/2 ) + (center.y  - self.frame.size.width/2 ) * (center.y  - self.frame.size.width/2 );
    if (length > ((self.frame.size.width/2 - self.selectedView.frame.size.width/2)*(self.frame.size.width/2 - self.selectedView.frame.size.width/2)))
    {
        float lengthTmp = sqrt(length);
        lengthTmp = (self.frame.size.width/2 - self.selectedView.frame.size.width/2) / lengthTmp;
        
        float yTmp = 0;
        float xTmp = 0;
        if (center.y < self.frame.size.width/2)
        {
            yTmp = ( self.frame.size.width/2 - center.y) * lengthTmp;
            yTmp = self.frame.size.width/2 - yTmp;
        }
        else
        {
            yTmp = (center.y - self.frame.size.width/2) * lengthTmp;
            yTmp = self.frame.size.width/2 + yTmp;
        }
        
        if (center.x < self.frame.size.width/2)
        {
            xTmp = (self.frame.size.width/2 - center.x) * lengthTmp;
            xTmp = self.frame.size.width/2 - xTmp;
        }
        else
        {
            xTmp = (center.x - self.frame.size.width/2) * lengthTmp;
            xTmp = self.frame.size.width/2 + xTmp;
        }
        
        center = CGPointMake(xTmp, yTmp);
    }
    self.movedPoint = center;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.selectedView.center = center;
    }];
}

-(float)computeSelectedLengthToCenter
{
    float length = (self.movedPoint.x  - self.frame.size.width/2 ) * (self.movedPoint.x  - self.frame.size.width/2 ) + (self.movedPoint.y  - self.frame.size.width/2 ) * (self.movedPoint.y  - self.frame.size.width/2 );
    length = sqrt(length);
    
    return length;
}

-(UIColor *)computeSelectedColorFromPoint
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -self.movedPoint.x, -self.movedPoint.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    CGFloat red = pixel[0] / 255.0;
    CGFloat green = pixel[1] / 255.0;
    CGFloat blue = pixel[2] / 255.0;
    CGFloat alpha = pixel[3] / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return color;
}

-(void)viewTouchEnded
{
    if ([self.circleDelegate respondsToSelector:@selector(touchEndThenCompute:)])
    {
        [self.circleDelegate touchEndThenCompute:self];
    }
}

#pragma mark touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[super touchesEnded:touches withEvent:event];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint center = [touch locationInView:self];
    
    [self moveSelectedViewPoint:center];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint center = [touch locationInView:self];
    
    [self moveSelectedViewPoint:center];
    
    [self viewTouchEnded];
    
    //[self computeSelectedColorFromPoint];
}

#pragma mark getter and setter
-(UIImageView *)selectedView
{
    if (!_selectedView)
    {
        CGRect rect = CGRectMake(0, 0, 22, 22);
        _selectedView = [[UIImageView alloc] initWithFrame:rect];
        _selectedView.image = [UIImage loadImageWithName:@"icon_color_sel_22x22"];
    }
    
    return _selectedView;
}


@end
