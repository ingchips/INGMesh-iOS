//
//  MeshPlaceAddViewController.m
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshPlaceAddViewController.h"
#import "MeshPlaceDatabase.h"

@interface MeshPlaceAddViewController ()

@property(nonatomic, strong)UITextField *nameField;
@property(nonatomic, strong)UITextField *keyField;
@property(nonatomic, strong)UIButton *showPasswordBtn;

@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIView *colorView;

@property(nonatomic, copy)NSString *imageName;
@property(nonatomic, copy)NSString *colorString;

@end

@implementation MeshPlaceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initContentUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self processCommand:self.pageCommand params:self.pageParams];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initContentUI
{
    //tip name
    float offset = self.navBar.frame.size.height;
    float leftOffset = 15;
    CGRect rect = CGRectMake(leftOffset, offset + 20, self.view.frame.size.width - 2 * leftOffset, 20);
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
    tipLabel.text = @"Place Name";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor bluePandroColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLabel];
    offset = offset + 40;
    
    //name
    [self.view addSubview:self.nameField];
    self.nameField.frame = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 40);
    offset = offset + 40;

    //line
    rect = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 0.5);
    [self.view addSubview:[UIView lineView:rect color:[UIColor littleGrayPandroColor]]];
    
    //tip key
    rect = CGRectMake(leftOffset, offset + 20, self.view.frame.size.width - 2 * leftOffset, 20);
    tipLabel = [[UILabel alloc] initWithFrame:rect];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor bluePandroColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.text = @"Key";
    [self.view addSubview:tipLabel];
    offset = offset + 40;
    
    //key
    [self.view addSubview:self.keyField];
    self.keyField.frame = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 40);
    offset = offset + 40;
    
    //button
    [self.view addSubview:self.showPasswordBtn];
    self.showPasswordBtn.frame = CGRectMake(0, offset, 50, 50);
    
    //tip
    float leftTmp = self.showPasswordBtn.frame.origin.x + self.showPasswordBtn.frame.size.width;
    rect = CGRectMake(leftTmp, self.showPasswordBtn.center.y - 10, self.view.frame.size.width -  leftOffset - leftTmp, 20);
    tipLabel = [[UILabel alloc] initWithFrame:rect];
    tipLabel.text = @"Show password";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor blackPandroColor];
    tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:tipLabel];
    
    offset = offset + 80;
    
    //icon and color
    {
        rect = CGRectMake((self.view.frame.size.width/2 - 100)/2, offset, 100, 80);
        UIControl *control = [[UIControl alloc] initWithFrame:rect];
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(clickIconBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:control];
        
        rect = CGRectMake(0, 0, 100, 30);
        tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.text = @"Icon";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor bluePandroColor];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [control addSubview:tipLabel];
        
        [control addSubview:self.imageView];
        self.imageView.frame = CGRectMake(25, 30, 50, 50);
        self.imageName = @"ic_home";
    }
    {
        
        rect = CGRectMake(self.view.frame.size.width/2 + (self.view.frame.size.width/2 - 100)/2, offset, 100, 80);
        UIControl *control = [[UIControl alloc] initWithFrame:rect];
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(clickColorBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:control];
        
        rect = CGRectMake(0, 0, 100, 30);
        tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.text = @"Color";
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor bluePandroColor];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [control addSubview:tipLabel];
        
        [control addSubview:self.colorView];
        self.colorView.frame = CGRectMake(25, 30, 50, 50);
        self.colorView.backgroundColor = [UIColor redColor];
        self.colorString = @"1.0,0,0";
        [self showIconWithColor];
        
    }
    offset = offset + 120;
    
    
    //save
    rect = CGRectMake(leftOffset, offset, self.view.frame.size.width - 2 * leftOffset, 40);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"save" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor bluePandroColor]];
    [btn.layer setCornerRadius:10];
    [btn.layer setMasksToBounds:YES];
    btn.frame = rect;
    [btn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
}


#pragma mark function
-(void)processCommand:(NSString *)command params:(NSDictionary *)params
{
    if ([command isEqualToString:@"icon"])
    {
        NSString *icon = [params valueForKey:@"icon"];
        if (icon)
        {
            self.imageName = icon;
            [self showIconWithColor];
        }
    }
    if ([command isEqualToString:@"color"])
    {
        NSString *colorStr = [params valueForKey:@"color"];
        if (colorStr)
        {
            self.colorString = colorStr;
            [self showIconWithColor];
        }
    }
}
-(void)showIconWithColor
{
    NSArray *array = [self.colorString componentsSeparatedByString:@","];
    if (array.count != 3)
    {
        return;
    }
    UIColor *tmpColor = [UIColor colorWithRed:[(NSString *)[array objectAtIndex:0] floatValue] green:[(NSString *)[array objectAtIndex:1] floatValue] blue:[(NSString *)[array objectAtIndex:2] floatValue] alpha:1];
    self.colorView.backgroundColor = tmpColor;
    self.imageView.tintColor = tmpColor;
    self.imageView.image = [[UIImage loadImageWithName:self.imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark click
-(void)clickShowPassword:(id)sender
{
    self.keyField.secureTextEntry = !self.keyField.secureTextEntry;
    if (!self.keyField.secureTextEntry)
    {
        [self.showPasswordBtn setImage:[UIImage loadImageWithName:@"ic_single_sel"] forState:UIControlStateNormal];
    }
    else
    {
        [self.showPasswordBtn setImage:[UIImage loadImageWithName:@"ic_single_unsel"] forState:UIControlStateNormal];
    }
}
-(void)clickIconBtn:(UIButton *)btn
{
    [self gotoPage:PAGE_GC_ICON_SEL_VIEWCONTROLLER params:nil command:nil];
}

-(void)clickColorBtn:(UIButton *)btn
{
    [self gotoPage:PAGE_GC_COLOR_SEL_VIEWCONTROLLER params:nil command:nil];
}

-(void)clickSaveBtn:(id)sender
{
    if (self.nameField.text.length == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Please input place name" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:0 handler:^(UIAlertAction * action) {
            //
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            //
        }];
        
        return;
    }
    NSString *errorMsg = [[MeshPlaceDatabase shareInstance] addPlace:self.nameField.text password:self.keyField.text  icon:self.imageName color:self.colorString favorite:NO];
    if (errorMsg)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:errorMsg delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alertView show];
        
        return;
    }
    
    [self popPage:nil command:nil];
}


#pragma mark setter and getter
-(UITextField *)nameField
{
    if (!_nameField)
    {
        _nameField = [[UITextField alloc] initWithFrame:CGRectZero];
        _keyField.font = [UIFont systemFontOfSize:20];
        _nameField.placeholder = @"name";
    }
    return _nameField;
}

-(UITextField *)keyField
{
    if (!_keyField)
    {
        _keyField = [[UITextField alloc] initWithFrame:CGRectZero];
        _keyField.placeholder = @"key";
        _keyField.font = [UIFont systemFontOfSize:20];
        _keyField.secureTextEntry = YES;
    }
    return _keyField;
}

-(UIButton *)showPasswordBtn
{
    if (!_showPasswordBtn)
    {
        _showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPasswordBtn setImage:[UIImage loadImageWithName:@"ic_single_unsel"] forState:UIControlStateNormal];
        [_showPasswordBtn addTarget:self action:@selector(clickShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordBtn;
}

-(UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

-(UIView *)colorView
{
    if (!_colorView)
    {
        _colorView = [[UIView alloc] init];
        _colorView.userInteractionEnabled = NO;
    }
    return _colorView;
}

@end
