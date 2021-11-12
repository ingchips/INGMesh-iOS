//
//  LampDeviceSetColorView.m
//  Pandro
//
//  Created by chun on 2019/1/15.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceSetColorView.h"
#import "PandroEngine.h"

@interface LampDeviceSetColorCircleView : UIImageView
{

}

@property(nonatomic, strong)UIImageView *selectedView;
@property(nonatomic)CGPoint movedPoint;

@end


@implementation LampDeviceSetColorCircleView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage loadImageWithName:@"ic_color_full_521x512"];
    
    self.image = image;
    
    [self addSubview:self.selectedView];
    self.selectedView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [self initRawData:nil];
    
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


-(void)computeSelectedColorFromPoint
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
    
    self.backgroundColor = color;
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
    [self computeSelectedColorFromPoint];
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


@interface LampDeviceSetColorView ()

@property(nonatomic, strong)LampDeviceSetColorCircleView *circleView;

@end

@implementation LampDeviceSetColorView

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
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:self.circleView];
    
    return self;
}


#pragma mark getter and setter
-(LampDeviceSetColorCircleView *)circleView
{
    if (!_circleView)
    {
        float width = self.frame.size.width - 100;
        CGRect rect = CGRectMake(50, 0, width, width);
        _circleView = [[LampDeviceSetColorCircleView alloc] initWithFrame:rect];
    }
        
    return _circleView;
}

@end
