//
//  MeshColorSelViewController.m
//  Pandro
//
//  Created by chun on 2018/12/25.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshColorSelViewController.h"

@interface MeshColorSelViewController ()

@property(nonatomic, strong)UISlider *redSlider;
@property(nonatomic, strong)UISlider *greenSlider;
@property(nonatomic, strong)UISlider *blueSlider;

@property(nonatomic, strong)UIView *colorView;

@end

@implementation MeshColorSelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float offset = self.navBar.frame.size.height + 30;
    
    
    [self.view addSubview:self.redSlider];
    CGRect rect = CGRectMake(15, offset, self.view.frame.size.width - 30, 50);
    self.redSlider.frame = rect;
    offset = offset + 80;
    
    [self.view addSubview:self.greenSlider];
    rect = CGRectMake(15, offset, self.view.frame.size.width - 30, 50);
    self.greenSlider.frame = rect;
    offset = offset + 80;
    
    [self.view addSubview:self.blueSlider];
    rect = CGRectMake(15, offset, self.view.frame.size.width - 30, 50);
    self.blueSlider.frame = rect;
    offset = offset + 80;
    
    [self.view addSubview:self.colorView];
    rect = CGRectMake(15, offset, self.view.frame.size.width - 30, 80);
    self.colorView.frame = rect;
    offset = offset + 80;
    
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1];
    
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"sue" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSure:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(15, offset, self.view.frame.size.width - 30, 50);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickSure:(UIButton *)sender
{
    NSString *colorStr = [NSString stringWithFormat:@"%.2f,%.2f,%.2f", self.redSlider.value/255.0, self.greenSlider.value/255.0, self.blueSlider.value/255.0];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:colorStr forKey:@"color"];
    
    [self popPage:dict command:@"color"];
}

-(void)sliderValueChange:(UISlider *)sender
{
    self.colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1];
}

#pragma mark getter and setter
-(UISlider *)redSlider
{
    if (!_redSlider)
    {
        _redSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _redSlider.minimumValue = 0;
        _redSlider.maximumValue = 255;
        [_redSlider setTintColor:[UIColor redColor]];
        [_redSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        _redSlider.value = 127.5;
    }
    
    return _redSlider;
}

-(UISlider *)greenSlider
{
    if (!_greenSlider)
    {
        _greenSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _greenSlider.minimumValue = 0;
        _greenSlider.maximumValue = 255;
        [_greenSlider setTintColor:[UIColor greenColor]];
        [_greenSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        _greenSlider.value = 127.5;
    }
    return _greenSlider;
}

-(UISlider *)blueSlider
{
    if (!_blueSlider)
    {
        _blueSlider = [[UISlider alloc] initWithFrame:CGRectZero];
        _blueSlider.minimumValue = 0;
        _blueSlider.maximumValue = 255;
        [_blueSlider setTintColor:[UIColor blueColor]];
        [_blueSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
        _blueSlider.value = 127.5;
    }
    
    return _blueSlider;
}

-(UIView *)colorView
{
    if (!_colorView)
    {
        _colorView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _colorView;
}

@end
