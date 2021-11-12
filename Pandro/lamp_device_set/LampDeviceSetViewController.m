//
//  LampDeviceSetViewController.m
//  Pandro
//
//  Created by chun on 2019/1/15.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceSetViewController.h"
#import "LampDeviceCircleColorView.h"
#import "LampDeviceCircleTemperatureView.h"
#import "LampDeviceRemoteControlView.h"
#import "LampDeviceSetHeaderView.h"
#import "MeshDeviceModel.h"
#import "PandroBlueToothMeshMgrOC.h"
#import "MeshPlaceDatabase.h"



@interface LampDeviceSetViewController ()
{
    int selectedSegIndex;
    BOOL showCircleColor;
}

@property(nonatomic, strong)UISegmentedControl *segControl;

@property(nonatomic, copy)NSString *placeId;
@property(nonatomic, copy)NSString *areaId;
@property(nonatomic, copy)NSString *deviceId;
@property(nonatomic, copy)NSArray *devicesArr;


@property(nonatomic, strong)UIView *contentView;

@property(nonatomic, strong)UIView *middleControlView;
@property(nonatomic, strong)LampDeviceSetHeaderView *headerControlView;
@property(nonatomic, strong)UIView *bottomControlView;

@property(nonatomic, strong)UILabel *remoteControlTipLabel;
@property(nonatomic, strong)UIView *opacityProgressView;
@property(nonatomic, strong)UISlider *sliderView;
@property(nonatomic, strong)UILabel *sliderValueView;

@property(nonatomic, strong)UIImageView *colorSelectedImgView;

@property(nonatomic, strong)UIView *setColorContentView;
@property(nonatomic, strong)UIView *interactiveContentView;

@property(nonatomic, strong)LampDeviceCircleColorView *circleColorView;
@property(nonatomic, strong)LampDeviceCircleTemperatureView *circleTemperView;

@property(nonatomic, strong)UIView *buttonsColorView;
@property(nonatomic, strong)UIView *buttonsColdView;
@property(nonatomic, strong)UIButton *buttonColorAndColdBtn;
@property(nonatomic, strong)UIButton *relayBtn;
@property(nonatomic, assign)NSInteger number;
@property(nonatomic, strong)NSString *strRelay;


@property(nonatomic, strong)UIView *colorBGView;
@property(nonatomic, strong)UILabel *temperatureLabel;

@end

@implementation LampDeviceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarTitle:@"设备控制"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomethingClick:) name:@"changeRelay" object:nil];

    
    /*
    selectedSegIndex = 0;
    [self.navBar addSubview:self.segControl];
    
    float width = 200;
    float height = 35;
    CGRect rect = CGRectMake((self.view.frame.size.width - width)/2, self.navBar.frame.size.height - height - 10, width, height);
    self.segControl.frame = rect;
    
    
    [self.view addSubview:self.contentView];
    
    [self.setColorContentView addSubview:self.circleTemperView];
    [self.circleTemperView setHidden:YES];
    
    [self.setColorContentView addSubview:self.circleColorView];
    */
     
    //{test begin
    /*
    self.colorBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.setColorContentView addSubview:self.colorBGView];
    self.colorBGView.backgroundColor = [UIColor whiteColor];
    
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0, 100, 20)];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.textAlignment = NSTextAlignmentRight;
    self.temperatureLabel.text = @"色温";
    [self.setColorContentView addSubview:self.temperatureLabel];
    
    rect = self.contentView.frame;
    rect.origin.x = -self.view.frame.size.width;
    self.contentView.frame = rect;
    */
    //}test end
    
    NSMutableDictionary *dictItem = self.pageParams;
    self.placeId = [dictItem valueForKey:@"placeId"];
    self.areaId = [dictItem valueForKey:@"areaId"];
    self.deviceId = [dictItem valueForKey:@"deviceId"];
    self.devicesArr = [dictItem valueForKey:@"devicesArr"];

    
    [self initContentUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


static void extracted(NSInteger number) {
    [[PandroBlueToothMeshMgrOC shareInstance] getRelayNum:number withIson:YES];
}

-(void)initContentUI
{
    float topOffset = self.navBar.frame.size.height + 60;
    CGRect rect = CGRectMake(15, topOffset, self.view.frame.size.width - 30, 35);
//    关闭顶部设置条设置
//    if (self.areaId)
//    {
//        self.headerControlView = [[LampDeviceSetHeaderView alloc] initWithFrame:rect];
//        //self.headerControlView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:self.headerControlView];
//
//        self.headerControlView.placeId = self.placeId;
//        self.headerControlView.areaId = self.areaId;
//        self.headerControlView.deviceId = self.deviceId;
//
//        [self.headerControlView initContentUI];
//    }
    //return;
    [self.view addSubview:self.middleControlView];
    rect = self.middleControlView.frame;
    rect.origin.y = topOffset;
//    if (self.headerControlView)
//    {
//        rect.origin.y = self.headerControlView.frame.origin.y + self.headerControlView.frame.size.height + 10;
//    }
    self.middleControlView.frame = rect;
    
//    [self.view addSubview:self.bottomControlView];
//    rect = self.bottomControlView.frame;
//    rect.origin.y = self.middleControlView.frame.origin.y + self.middleControlView.frame.size.height + 10;
//    self.bottomControlView.frame = rect;
//    
    [self initButtonColorContent_second];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, self.navBar.frame.size.height + 10, self.view.frame.size.width - 30, 40)];
    textField.placeholder = @"请输入纯数字操作码";
    textField.font = [UIFont boldSystemFontOfSize:15];
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textField];



    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除设备" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn.layer setCornerRadius:10];
    [deleteBtn.layer setMasksToBounds:YES];
    deleteBtn.frame = CGRectMake(15, CGRectGetMaxY(self.middleControlView.frame) + 20, self.view.frame.size.width/3 - 30, 48);
    [deleteBtn addTarget:self action:@selector(clickDeleteDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    UIButton *deleteBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn2 setTitle:@"强制删除" forState:UIControlStateNormal];
    [deleteBtn2 setBackgroundColor:[UIColor whiteColor]];
    [deleteBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteBtn2.layer setCornerRadius:10];
    [deleteBtn2.layer setMasksToBounds:YES];
    deleteBtn2.frame = CGRectMake(self.view.frame.size.width/3 +15, CGRectGetMaxY(self.middleControlView.frame) + 20, self.view.frame.size.width/3 - 30, 48);
    [deleteBtn2 addTarget:self action:@selector(clickDeleteDeviceBtnlocal:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn2];
    
    UIButton *relayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [relayBtn setTitle:@"获取relay" forState:UIControlStateNormal];
    [relayBtn setBackgroundColor:[UIColor whiteColor]];
    [relayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [relayBtn.layer setCornerRadius:10];
    [relayBtn.layer setMasksToBounds:YES];
    relayBtn.frame = CGRectMake(self.view.frame.size.width*2/3 + 15,CGRectGetMaxY(self.middleControlView.frame) + 20 , self.view.frame.size.width/3 - 30, 48);
    [relayBtn addTarget:self action:@selector(relayBtnDeviceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:relayBtn];
    self.relayBtn = relayBtn;
    self.strRelay = @"0";
    NSInteger number = 0;
    for (MeshDeviceModel *deviceModel in self.devicesArr)
        {
            if ([self.deviceId isEqualToString:deviceModel.deviceId]) {
                break;
            }
            number++;
        }
    self.number = number;
    extracted(number);
}
-(void) doSomethingClick:(NSNotification *)notification
{
    NSString *Str = notification.userInfo[@"changeRelay"];
    NSString *removeDevice = notification.userInfo[@"removeDeviceNode"];

    self.strRelay = Str;
    __weak __typeof(self) weakself= self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakself.strRelay isEqualToString:@"0"]) {
            [weakself.relayBtn setTitle:@"添加relay" forState:UIControlStateNormal];
        }else if ([weakself.strRelay isEqualToString:@"1"]) {
            [weakself.relayBtn setTitle:@"解除relay" forState:UIControlStateNormal];
        }else if ([weakself.strRelay isEqualToString:@"2"]) {
            [weakself.relayBtn setTitle:@"该设备不支持relay功能" forState:UIControlStateNormal];
            [weakself.relayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    });
    if (removeDevice && [removeDevice isEqualToString:@"1"]) {
        [[MeshPlaceDatabase shareInstance] deleteAreaDeviceFromPlace:self.placeId deviceId:self.deviceId];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//删除设备
- (void)removeDeviceNode
{
    [self performSelector:@selector(deleteAreaDevice) withObject:nil afterDelay:0.2f];
    [[PandroBlueToothMeshMgrOC shareInstance] removeDeviceNode:self.number];

}
//本地删除设备
- (void)removeDeviceNodelocal
{
    [self performSelector:@selector(deleteAreaDevice) withObject:nil afterDelay:0.2f];
    [[PandroBlueToothMeshMgrOC shareInstance] removeDeviceNodelocal:self.number];

}

- (void)deleteAreaDevice
{
    [[MeshPlaceDatabase shareInstance] deleteAreaDeviceFromPlace:self.placeId deviceId:self.deviceId];
    [[MeshPlaceDatabase shareInstance] refreshDatabase];
    [[PandroBlueToothMeshMgrOC shareInstance] myDevice];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark fun
-(void)relayBtnDeviceBtn:(UIButton *)btn
{
    [self.view showAnimationTip:@"点击relay成功，请等待设置结果" topOffset:0];

    if ([self.strRelay isEqualToString:@"0"]) {
        [[PandroBlueToothMeshMgrOC shareInstance] setRelayNum:self.number withIson:YES];

    }else if ([self.strRelay isEqualToString:@"1"]){
        [[PandroBlueToothMeshMgrOC shareInstance] setRelayNum:self.number withIson:NO];
    }
}
#pragma mark fun
-(void)clickDeleteDeviceBtn:(UIButton *)btn
{
    NSString *msg = @"确定要删除设备么？";
    if([self.relayBtn.titleLabel.text isEqualToString:@"获取relay"])
    {
        msg = @"当前设备通信异常，请检查设备链接是否正常，如果在链接异常下删除此设备，删除后需要对设备进行手动复位";
    }
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertCon dismissViewControllerAnimated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            [weakSelf removeDeviceNode];
        }];
        
        //
    }];
    [alertCon addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alertCon addAction:cancelAction];
    
    
    [self presentViewController:alertCon animated:YES completion:^{
        //
    }];
}

-(void)clickDeleteDeviceBtnlocal:(UIButton *)btn
{
    NSString *msg = @"确定要删除设备么？";
    if([self.relayBtn.titleLabel.text isEqualToString:@"获取relay"])
    {
        msg = @"强制本地删除设备而不通知对端";
    }
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertCon dismissViewControllerAnimated:YES completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:0.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
            //
            [weakSelf removeDeviceNodelocal];
        }];
        
        //
    }];
    [alertCon addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alertCon addAction:cancelAction];
    
    
    [self presentViewController:alertCon animated:YES completion:^{
        //
    }];
}

-(void)initButtonColorContent_second
{
    //create buttons super view
    float topOffset = self.opacityProgressView.frame.origin.y + self.opacityProgressView.frame.size.height + 15;
    CGRect rect = CGRectMake(0, topOffset, self.view.frame.size.width, self.middleControlView.frame.size.height - topOffset);
    
    self.buttonsColdView = [[UIView alloc] initWithFrame:rect];
    self.buttonsColdView.backgroundColor = [UIColor clearColor];
    [self.middleControlView addSubview:self.buttonsColdView];
    [self.buttonsColdView setHidden:YES];
    
    self.buttonsColorView = [[UIView alloc] initWithFrame:rect];
    self.buttonsColorView.backgroundColor = [UIColor clearColor];
    [self.middleControlView addSubview:self.buttonsColorView];
    
    
    float width = 40;
    float offset = (self.middleControlView.frame.size.width - 40 * 4)/5;
    int index = 0;
    
    
    //add temperature button
    
    NSMutableArray *coldBtnArray = [[NSMutableArray alloc] init];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"3000K", @"color":@"1.0", @"image":@"lamp_device_set_cold_1"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"3500K", @"color":@"0.8", @"image":@"lamp_device_set_cold_2"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"4000K", @"color":@"0.6", @"image":@"lamp_device_set_cold_3"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"4500K", @"color":@"0.4", @"image":@"lamp_device_set_cold_4"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"5000K", @"color":@"0.2", @"image":@"lamp_device_set_cold_5"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"5500K", @"color":@"0.1", @"image":@"lamp_device_set_cold_6"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"6000K", @"color":@"0", @"image":@"lamp_device_set_cold_7"}];
    
    
    index = 0;
    for (NSMutableDictionary *dictItem in coldBtnArray)
    {
        rect = CGRectMake(offset + (index % 4) * (width + offset), (width + 20) * (index / 4), width, width);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        [btn setImage:[UIImage loadImageWithName:[dictItem valueForKey:@"image"]] forState:UIControlStateNormal];
        btn.accessibilityValue = [dictItem valueForKey:@"color"];
        [btn addTarget:self action:@selector(clickImageColdBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonsColdView addSubview:btn];
        
        index++;
    }
    
    //add color button
    
    NSMutableArray *colorBtnArray = [[NSMutableArray alloc] init];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"红", @"color":@"0XFF0000FF", @"image":@"lamp_device_set_color_red"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"橙", @"color":@"0XFD6D00FF", @"image":@"lamp_device_set_color_orange"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"黄", @"color":@"0XFFFF00FF", @"image":@"lamp_device_set_color_yellow"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"绿", @"color":@"0X00FF00FF", @"image":@"lamp_device_set_color_green"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"青", @"color":@"0X00FFFFFF", @"image":@"lamp_device_set_color_ching"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"蓝", @"color":@"0X0000FFFF", @"image":@"lamp_device_set_color_blue"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"紫", @"color":@"0X6D00FDFF", @"image":@"lamp_device_set_color_purple"}];
    
    index = 0;
    for (NSMutableDictionary *dictItem in colorBtnArray)
    {
        rect = CGRectMake(offset + (index % 4) * (width + offset), (width + 20) * (index / 4), width, width);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = rect;
        [btn setImage:[UIImage loadImageWithName:[dictItem valueForKey:@"image"]] forState:UIControlStateNormal];
        btn.accessibilityValue = [dictItem valueForKey:@"color"];
        [btn addTarget:self action:@selector(clickImageColorBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.buttonsColorView addSubview:btn];
        
        index++;
    }
    
    [self.middleControlView addSubview:self.colorSelectedImgView];
    [self.colorSelectedImgView setHidden:YES];
    
    
    //add color and temperature button
    showCircleColor = TRUE;
    
    rect = CGRectMake(self.middleControlView.frame.size.width - width - offset, topOffset + 20 + width, width, width);
    
    self.buttonColorAndColdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buttonColorAndColdBtn.frame = rect;
    [self.buttonColorAndColdBtn addTarget:self action:@selector(clickImageColorColdBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonColorAndColdBtn setImage:[UIImage loadImageWithName:@"lamp_device_set_color_colorcold"] forState:UIControlStateNormal];

    [self.middleControlView addSubview:self.buttonColorAndColdBtn];
    
}

-(void)initButtonColorContent
{
    //create buttons super view
    float topOffset = self.opacityProgressView.frame.origin.y + self.opacityProgressView.frame.size.height;
    CGRect rect = CGRectMake(0, topOffset, self.view.frame.size.width, self.view.frame.size.height - topOffset);
    
    self.buttonsColdView = [[UIView alloc] initWithFrame:rect];
    self.buttonsColdView.backgroundColor = [UIColor clearColor];
    [self.middleControlView addSubview:self.buttonsColdView];
    [self.buttonsColdView setHidden:YES];
    
    self.buttonsColorView = [[UIView alloc] initWithFrame:rect];
    self.buttonsColorView.backgroundColor = [UIColor clearColor];
    [self.middleControlView addSubview:self.buttonsColorView];
    
    
    float width = self.view.frame.size.width / 4;
    float height = width + 20;
    int index = 0;
    
    //add temperature button
    
    NSMutableArray *coldBtnArray = [[NSMutableArray alloc] init];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"3000K", @"color":@"1.0", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"3500K", @"color":@"0.8", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"4000K", @"color":@"0.6", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"4500K", @"color":@"0.4", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"5000K", @"color":@"0.2", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"5500K", @"color":@"0.1", @"coor":@"100-200"}];
    [coldBtnArray addObject:@{@"identifier":@"cold", @"title":@"6000K", @"color":@"0", @"coor":@"100-200"}];
    
    index = 0;
    for (NSMutableDictionary *dictItem in coldBtnArray)
    {
        rect = CGRectMake((index % 4) * width,  height * (index/4), width, height);
        
        UIImageView *imageView = nil;
        PandroButton *pandroBtn = [self createColorPandroButtonWithFrame:rect imageView:&imageView];
        [self.buttonsColdView addSubview:pandroBtn];
        
        pandroBtn.btnIdentifier = [dictItem valueForKey:@"identifier"];
        pandroBtn.dictItem = dictItem;
        pandroBtn.titleLabe.text = [dictItem valueForKey:@"title"];
        imageView.image = [UIImage loadImageWithName:@"warm_cold_icon_59x60_"];
        imageView.alpha = [[dictItem valueForKey:@"color"] floatValue];
        
        index++;
    }
    
    //add color button
    
    NSMutableArray *colorBtnArray = [[NSMutableArray alloc] init];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"红", @"color":@"0XFF0000FF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"橙", @"color":@"0XFD6D00FF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"黄", @"color":@"0XFFFF00FF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"绿", @"color":@"0X00FF00FF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"青", @"color":@"0X00FFFFFF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"蓝", @"color":@"0X0000FFFF", @"coor":@"100-200"}];
    [colorBtnArray addObject:@{@"identifier":@"color", @"title":@"紫", @"color":@"0X6D00FDFF", @"coor":@"100-200"}];
    
    index = 0;
    for (NSMutableDictionary *dictItem in colorBtnArray)
    {
        rect = CGRectMake((index % 4) * width,  height * (index/4), width, height);
        
        UIImageView *imageView = nil;
        PandroButton *pandroBtn = [self createColorPandroButtonWithFrame:rect imageView:&imageView];
        [self.buttonsColorView addSubview:pandroBtn];
        
        pandroBtn.btnIdentifier = [dictItem valueForKey:@"identifier"];
        pandroBtn.dictItem = dictItem;
        pandroBtn.titleLabe.text = [dictItem valueForKey:@"title"];
        imageView.backgroundColor = [UIColor colorWithHexString:[dictItem valueForKey:@"color"]];
        
        index++;
    }
    
    /*
    //add color and temperature button
    showCircleColor = TRUE;
    
    rect = CGRectMake(self.view.frame.size.width - width, topOffset + height, width, height);
    UIImageView *tmpView = nil;
    self.buttonColorAndColdBtn = [self createColorPandroButtonWithFrame:rect imageView:&tmpView];
    self.buttonColorAndColdBtn.titleLabe.text = @"色温";
    self.buttonColorAndColdBtn.imageView.image = [UIImage loadImageWithName:@"warm_cold_icon_59x60_"];
    [tmpView setHidden:YES];
    [self.setColorContentView addSubview:self.buttonColorAndColdBtn];
    */
}

-(PandroButton *)createColorPandroButtonWithFrame:(CGRect)rect imageView:(UIImageView **)imageView
{
    float circleWidth = rect.size.width - rect.size.width/3;
    
    PandroButton *colorBtn = [[PandroButton alloc] initWithFrame:rect];
    colorBtn.delegate = self;
    
    colorBtn.imageView.frame = CGRectMake((rect.size.width - circleWidth)/2, 5, circleWidth, circleWidth);
    colorBtn.imageView.backgroundColor = [UIColor whiteColor];
    [colorBtn.imageView.layer setCornerRadius:circleWidth/2];
    [colorBtn.imageView.layer setMasksToBounds:YES];
    
    
    colorBtn.titleLabe.frame = CGRectMake(0, colorBtn.imageView.frame.origin.y + colorBtn.imageView.frame.size.height + 10, rect.size.width, 20);
    colorBtn.titleLabe.font = [UIFont systemFontOfSize:15];
    
    float tmpViewWidth = circleWidth - 6;
    rect = CGRectMake(3, 3, tmpViewWidth, tmpViewWidth);
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:rect];
    [colorBtn.imageView addSubview:tmpView];
    [tmpView.layer setCornerRadius:tmpViewWidth/2];
    [tmpView.layer setMasksToBounds:YES];
    *imageView = tmpView;
    
    return colorBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark fun

-(void)clickRemoteControl:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    
    CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navBar.frame.size.height);
    LampDeviceRemoteControlView *remoteConView = [[LampDeviceRemoteControlView alloc] initWithFrame:rect];
    
    rect.origin.y = self.view.frame.size.height;
    remoteConView.frame = rect;
    
    [self.view addSubview:remoteConView];
    __block CGRect animRect = rect;
    [UIView animateWithDuration:0.1 animations:^{
        //
        animRect.origin.y = weakSelf.navBar.frame.size.height;
        remoteConView.frame = animRect;
    }];
    
    remoteConView.clickedBlock = ^BOOL(NSString *name) {
        //
        return YES;
    };
    
    
}

-(void)sliderValueChanged:(UISlider *)slider
{
    self.sliderValueView.text = [NSString stringWithFormat:@"%d%%", (int)(self.sliderView.value * 100)];
    
    CGRect rect = self.sliderValueView.frame;
    rect.origin.x = self.sliderView.value * self.sliderView.frame.size.width;
    if (rect.origin.x >= (self.sliderView.frame.size.width - 50))
    {
        rect.origin.x = self.sliderView.frame.size.width - 50;
    }
    self.sliderValueView.frame = rect;
}

-(void)clickImageColorColdBtn:(UIButton *)btn
{
    [self.colorSelectedImgView setHidden:YES];
    
    if (showCircleColor)
    {
        [self.buttonsColorView setHidden:YES];
        [self.circleColorView setHidden:YES];
        
        [self.buttonsColdView setHidden:NO];
        [self.circleTemperView setHidden:NO];
        
        [self.buttonColorAndColdBtn setImage:[UIImage loadImageWithName:@"lamp_device_set_color_coldcolor"] forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonsColorView setHidden:NO];
        [self.circleColorView setHidden:NO];
        
        [self.buttonsColdView setHidden:YES];
        [self.circleTemperView setHidden:YES];
        
        [self.buttonColorAndColdBtn setImage:[UIImage loadImageWithName:@"lamp_device_set_color_colorcold"] forState:UIControlStateNormal];
    }
    
    showCircleColor = !showCircleColor;
}

-(void)clickImageColdBtn:(UIButton *)btn
{
    [self.colorSelectedImgView setHidden:NO];
    
    CGRect rect = [self.middleControlView convertRect:btn.frame fromView:self.buttonsColdView];
    
    CGRect rectNew = self.colorSelectedImgView.frame;
    rectNew.origin.x = rect.origin.x + (rect.size.width - rectNew.size.width)/2;
    rectNew.origin.y = rect.origin.y + (rect.size.height - rectNew.size.height)/2;
    self.colorSelectedImgView.frame = rectNew;
}

-(void)clickImageColorBtn:(UIButton *)btn
{
    [self.colorSelectedImgView setHidden:NO];
    
    CGRect rect = [self.middleControlView convertRect:btn.frame fromView:self.buttonsColorView];
    
    CGRect rectNew = self.colorSelectedImgView.frame;
    rectNew.origin.x = rect.origin.x + (rect.size.width - rectNew.size.width)/2;
    rectNew.origin.y = rect.origin.y + (rect.size.height - rectNew.size.height)/2;
    self.colorSelectedImgView.frame = rectNew;
    
}

-(void)clickedSegment
{
    if (selectedSegIndex == self.segControl.selectedSegmentIndex)
    {
        return;
    }
    
    selectedSegIndex = self.segControl.selectedSegmentIndex;
    
    float left = 0;
    if (selectedSegIndex == 1)
    {
        left = -self.view.frame.size.width;
    }
    
    CGRect rect = self.contentView.frame;
    rect.origin.x = left;
    [UIView animateWithDuration:0.1 animations:^{
        self.contentView.frame = rect;
    }];
}

-(void)clickedPandroButtonOfColorAndCold:(PandroButton *)button
{
    if (showCircleColor)
    {
        [self.buttonsColorView setHidden:YES];
        [self.circleColorView setHidden:YES];
        
        [self.buttonsColdView setHidden:NO];
        [self.circleTemperView setHidden:NO];
        
        //self.buttonColorAndColdBtn.titleLabe.text = @"彩色";
        //self.buttonColorAndColdBtn.imageView.image = [UIImage loadImageWithName:@"color_icon_59x60_"];
    }
    else
    {
        [self.buttonsColorView setHidden:NO];
        [self.circleColorView setHidden:NO];
        
        [self.buttonsColdView setHidden:YES];
        [self.circleTemperView setHidden:YES];
        
        //self.buttonColorAndColdBtn.titleLabe.text = @"色温";
        //self.buttonColorAndColdBtn.imageView.image = [UIImage loadImageWithName:@"warm_cold_icon_59x60_"];
    }
    
    showCircleColor = !showCircleColor;
    
}

-(void)clickedPandroButtonOfColor:(PandroButton *)button
{
    NSDictionary *dictItem = button.dictItem;
    self.colorBGView.backgroundColor = [UIColor colorWithHexString:[dictItem valueForKey:@"color"]];
    
    NSArray *arrayCenter = [[dictItem valueForKey:@"coor"] componentsSeparatedByString:@"-"];
    if (arrayCenter.count == 2)
    {
        CGPoint center = CGPointMake([[arrayCenter objectAtIndex:0] floatValue], [[arrayCenter objectAtIndex:0] floatValue]);
        //self.circleColorView.selectedView.center = center;
    }
    
}
-(void)clickedPandroButtonOfCold:(PandroButton *)button
{
    NSDictionary *dictItem = button.dictItem;
    
    self.temperatureLabel.text = [dictItem valueForKey:@"title"];
}

#pragma mark pandorbutton delegate
-(void)clickedPandroButton:(PandroButton *)button
{
    if ([button isEqual:self.buttonColorAndColdBtn])
    {
        [self clickedPandroButtonOfColorAndCold:button];
        return;
    }
    if ([button.btnIdentifier hasPrefix:@"color"])
    {
        [self clickedPandroButtonOfColor:button];
    }
    else if ([button.btnIdentifier hasPrefix:@"cold"])
    {
        [self clickedPandroButtonOfCold:button];
    }
}


#pragma mark circleview delegate
-(void)touchEndThenCompute:(PandroCircleSelectView *)circleView
{
    if ([circleView isEqual:self.circleColorView])
    {
        UIColor *color = [self.circleColorView computeSelectedColorFromPoint];
        
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        BOOL success = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        NSLog(@"success: %i hue: %0.2f,saturation: %0.2f,brightness: %0.2f,alpha: %0.2f",success,hue,saturation,brightness,alpha);
        [[PandroBlueToothMeshMgrOC shareInstance] setLightHSLSet:self.number WithSaturation:saturation*65535 Withlightness:saturation*65535 Withhue:hue*65535];
        self.colorBGView.backgroundColor = color;
    }
    else if ([circleView isEqual:self.circleTemperView])
    {
        float length = [self.circleTemperView computeSelectedLengthToCenter];
        float radius = (self.circleTemperView.frame.size.width - self.circleTemperView.selectedView.frame.size.width )/2;
        float tmperature = 800 + 19200 * (length/radius);
        [[PandroBlueToothMeshMgrOC shareInstance] setLightCTLSet:self.number WithTemperature:tmperature Withlightness:self.sliderView.value * 65535];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%d", (int)tmperature];
    }
}

#pragma mark getter and setter
-(UISegmentedControl *)segControl
{
    if (!_segControl)
    {
        _segControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        _segControl.tintColor = [UIColor whiteColor];
        [_segControl insertSegmentWithTitle:@"调色" atIndex:0 animated:NO];
        [_segControl insertSegmentWithTitle:@"互动" atIndex:1 animated:NO];
        [_segControl addTarget:self action:@selector(clickedSegment) forControlEvents:UIControlEventValueChanged];
    }
    
    return _segControl;
}

-(UIView *)contentView
{
    if (!_contentView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height,  2 * self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        
        _contentView = [[UIView alloc] initWithFrame:rect];
        
        rect = CGRectMake(0, 0,  self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        self.setColorContentView = [[UIView alloc] initWithFrame:rect];
        self.setColorContentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.setColorContentView];
        
        rect = CGRectMake(self.view.frame.size.width, 0,  self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        self.interactiveContentView = [[UIView alloc] initWithFrame:rect];
        self.interactiveContentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.interactiveContentView];
    }
    return _contentView;
}

-(UIView *)opacityProgressView
{
    if (!_opacityProgressView)
    {
        float left = 50;
        float width = self.view.frame.size.width - 2 * left;
        
        CGRect rect = CGRectMake(0, 0, width, 60);
        _opacityProgressView = [[UIView alloc] initWithFrame:rect];
        //_opacityProgressView.backgroundColor = [UIColor grayColor];
        
        
        float height = 30;
        rect = CGRectMake(0, _opacityProgressView.frame.size.height - height, _opacityProgressView.frame.size.width, height);
        self.sliderView = [[UISlider alloc] initWithFrame:rect];
        [_opacityProgressView addSubview:self.sliderView];
        
        self.sliderView.value = 0.5;
        self.sliderView.maximumTrackTintColor = [UIColor colorWithHexString:@"FFBFBFFF"];
        self.sliderView.minimumTrackTintColor = [UIColor colorWithHexString:@"FF3219FF"];
        
        [self.sliderView addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        rect = CGRectMake(0, 5, 50, 20);
        self.sliderValueView = [[UILabel alloc] initWithFrame:rect];
        self.sliderValueView.backgroundColor = [UIColor clearColor];
        self.sliderValueView.font = [UIFont systemFontOfSize:18];
        self.sliderValueView.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
        [_opacityProgressView addSubview:self.sliderValueView];
        
        [self sliderValueChanged:self.sliderView];
        
    }
    return _opacityProgressView;
}

-(UIView *)middleControlView
{
    if (!_middleControlView)
    {
        float controlWidth = (self.view.frame.size.width - 30)/4;
        float height = self.view.frame.size.width + controlWidth - 10;
        CGRect rect = CGRectMake(15, 40, self.view.frame.size.width - 30, height);
        _middleControlView = [[UIView alloc] initWithFrame:rect];
        
        _middleControlView.layer.shadowColor = [UIColor bluePandroColor].CGColor;
        _middleControlView.layer.shadowOffset = CGSizeMake(5, 5);
        _middleControlView.layer.shadowRadius = 2;
        _middleControlView.layer.shadowOpacity = 0.2;
        
        rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
        UIView *colorView = [[UIView alloc] initWithFrame:rect];
        colorView.userInteractionEnabled = NO;
        colorView.backgroundColor = [UIColor whiteColor];
        [colorView.layer setCornerRadius:5];
        [colorView.layer setMasksToBounds:YES];
        [_middleControlView addSubview:colorView];
        
        //circle color
        [_middleControlView addSubview:self.circleTemperView];
        [self.circleTemperView setHidden:YES];
        [_middleControlView addSubview:self.circleColorView];
        float topOffset = 10;
        rect = self.circleTemperView.frame;
        rect = CGRectMake((_middleControlView.frame.size.width - rect.size.width)/2, topOffset, rect.size.width, rect.size.height);
        self.circleTemperView.frame = rect;
        self.circleColorView.frame = rect;
        
        //opacity
        topOffset = topOffset + rect.size.height;
        [_middleControlView addSubview:self.opacityProgressView];
        rect = self.opacityProgressView.frame;
        rect = CGRectMake((_middleControlView.frame.size.width - rect.size.width)/2, topOffset, rect.size.width, rect.size.height);
        self.opacityProgressView.frame = rect;
    }
    return _middleControlView;
}

-(UIView *)bottomControlView
{
    if (!_bottomControlView)
    {
        float height = 56;
        CGRect rect = CGRectMake(15, 0, self.view.frame.size.width - 30, height);
        UIControl *control = [[UIControl alloc] initWithFrame:rect];
        [control addTarget:self action:@selector(clickRemoteControl:) forControlEvents:UIControlEventTouchUpInside];
        //control.backgroundColor = [UIColor clearColor];
        
        control.layer.shadowColor = [UIColor bluePandroColor].CGColor;
        control.layer.shadowOffset = CGSizeMake(5, 5);
        control.layer.shadowRadius = 2;
        control.layer.shadowOpacity = 0.2;
        
        rect = CGRectMake(0, 0, rect.size.width, rect.size.height);
        UIView *colorView = [[UIView alloc] initWithFrame:rect];
        colorView.userInteractionEnabled = NO;
        colorView.backgroundColor = [UIColor whiteColor];
        [colorView.layer setCornerRadius:5];
        [colorView.layer setMasksToBounds:YES];
        [control addSubview:colorView];
        
        _bottomControlView = control;
        
        //add tip
        rect = CGRectMake(15, 0, 100, height);
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textColor = [UIColor blackPandroColor];
        tipLabel.text = @"遥控器按键";
        [control addSubview:tipLabel];
        
        //add icon
        float rightOffset = control.frame.size.width - 15 - 7;
        rect = CGRectMake(rightOffset, (height - 12)/2, 7, 12);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        imgView.image = [UIImage loadImageWithName:@"lamp_mesh_cell_right"];
        [control addSubview:imgView];
        
        //haha
        rightOffset = rightOffset - 15;
        float leftOffset = control.frame.size.width/2;
        rect = CGRectMake(leftOffset, 0, rightOffset - leftOffset, height);
        self.remoteControlTipLabel  = [[UILabel alloc] initWithFrame:rect];
        self.remoteControlTipLabel.backgroundColor = [UIColor clearColor];
        self.remoteControlTipLabel.font = [UIFont systemFontOfSize:15];
        self.remoteControlTipLabel.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
        self.remoteControlTipLabel.text = @"未设置";
        self.remoteControlTipLabel.textAlignment = NSTextAlignmentRight;
        [control addSubview:self.remoteControlTipLabel];
        
    }
    return _bottomControlView;
    
}

-(UIImageView *)colorSelectedImgView
{
    if (!_colorSelectedImgView)
    {
        _colorSelectedImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 14)];
        _colorSelectedImgView.image = [UIImage loadImageWithName:@"lamp_device_set_color_sel"];
    }
    return _colorSelectedImgView;
}

-(LampDeviceCircleColorView *)circleColorView
{
    if (!_circleColorView)
    {
        float left = 65;
        float width = self.view.frame.size.width - 2 * left;
        
        CGRect rect = CGRectMake(0, 0, width, width);
        _circleColorView = [[LampDeviceCircleColorView alloc] initWithFrame:rect];
        _circleColorView.circleDelegate = self;
    }
    return _circleColorView;
}

-(LampDeviceCircleTemperatureView *)circleTemperView
{
    if (!_circleTemperView)
    {
        float left = 65;
        float width = self.view.frame.size.width - 2 * left;
        
        CGRect rect = CGRectMake(0, 0, width, width);
        _circleTemperView = [[LampDeviceCircleTemperatureView alloc] initWithFrame:rect];
        _circleTemperView.circleDelegate = self;
    }
    return _circleTemperView;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [[PandroBlueToothMeshMgrOC shareInstance] setNumber:self.number WithSaturationNumber:[textField.text integerValue] + 800];

    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeRelay" object:self];
}

@end
