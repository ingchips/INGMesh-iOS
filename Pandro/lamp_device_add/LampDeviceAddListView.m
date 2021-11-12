//
//  LampDeviceAddListView.m
//  Pandro
//
//  Created by chun on 2019/2/28.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampDeviceAddListView.h"
#import "PandroEngine.h"
#import "LampDeviceAddViewController.h"
#import "PandroBlueToothMeshMgrBridge.h"
#import "PandroBlueToothMeshMgrOC.h"

enum
{
    DEVICE_MODEL_STATE_DEFAULT = 0,
    DEVICE_MODEL_STATE_SELECTED,
    DEVICE_MODEL_STATE_CONNECTED
};



@implementation LampDeviceAddListCellModel


@end

@interface LampDeviceAddListCell : UITableViewCell

@property(nonatomic, strong)LampDeviceAddListCellModel *deviceModel;

@property(nonatomic, strong)UILabel *deviceNameLabel;
@property(nonatomic, strong)UILabel *conectedTipLabel;
@property(nonatomic, strong)UIImageView *selectedImgView;

-(void)showContentDevice:(LampDeviceAddListCellModel *)deviceModel;

@end

@implementation LampDeviceAddListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.deviceNameLabel.font = [UIFont systemFontOfSize:15];
    self.deviceNameLabel.textColor = [UIColor blackPandroColor];
    self.deviceNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.deviceNameLabel];
    
    
    self.conectedTipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.conectedTipLabel.font = [UIFont systemFontOfSize:15];
    self.conectedTipLabel.textColor = [UIColor colorWithHexString:@"A9B3BDFF"];
    self.conectedTipLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.conectedTipLabel];
    self.conectedTipLabel.textAlignment = NSTextAlignmentRight;
    self.conectedTipLabel.text = @"已接入";
    
    self.selectedImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.selectedImgView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.deviceNameLabel.frame = CGRectMake(15, 0, self.frame.size.width - 130, self.frame.size.height);
    self.conectedTipLabel.frame = CGRectMake(self.frame.size.width - 100, 0, 100 - 15, self.frame.size.height);
    
    self.selectedImgView.frame = CGRectMake(self.frame.size.width - 18 - 15, (self.frame.size.height - 18)/2, 18, 18);
}

-(void)showContentDevice:(LampDeviceAddListCellModel *)deviceModel
{
    self.deviceModel = deviceModel;
    self.deviceNameLabel.text = deviceModel.deviceName;
    
    [self.conectedTipLabel setHidden:YES];
    [self.selectedImgView setHidden:YES];
    
    if (deviceModel.deviceState == DEVICE_MODEL_STATE_DEFAULT)
    {
        [self.selectedImgView setHidden:NO];
        self.selectedImgView.image = [UIImage loadImageWithName:@"device_list_device_default"];
    }
    else if (deviceModel.deviceState == DEVICE_MODEL_STATE_SELECTED)
    {
        [self.selectedImgView setHidden:NO];
        self.selectedImgView.image = [UIImage loadImageWithName:@"device_list_device_sel"];
    }
    else if (deviceModel.deviceState == DEVICE_MODEL_STATE_CONNECTED)
    {
        [self.conectedTipLabel setHidden:NO];
    }
}

@end


@interface LampDeviceAddListView()
{
    BOOL checkSelectedAll;
}


@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *deviceArray;

//@property(nonatomic, strong)UIControl *selectAllBtn;
@property(nonatomic, strong)UIImageView *selectAllImgView;

@property(nonatomic, strong)UIButton *connectBtn;
//@property(nonatomic, strong)UIButton *directGotoBtn;

@end

@implementation LampDeviceAddListView



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
    self.backgroundColor = [UIColor whiteColor];
    
    {
        CGRect rect = CGRectMake(15, 0, self.frame.size.width - 30, 50);
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:rect];
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textColor = [UIColor blackPandroColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = @"选择接入设备";
        [self addSubview:tipLabel];
    }

    [self loadDeviceData];
    [self adjustConnectAndGotoBtn];
    
    return self;
}

#pragma mark fun
-(void)showBlueToothDeviceContent
{
    [self loadDeviceData];
    [self adjustConnectAndGotoBtn];
}

-(void)loadDeviceData
{
    self.deviceArray = [[NSMutableArray alloc] init];
    
    /*
    for (int i=0; i<15; i++)
    {
        LampDeviceAddListCellModel *model = [[LampDeviceAddListCellModel alloc] init];
        model.deviceName = [NSString stringWithFormat:@"ceshi %d", i];
        
        if (i < 2)
        {
            model.deviceState = DEVICE_MODEL_STATE_CONNECTED;
        }
        [self.deviceArray addObject:model];
    }
    */
    for (CBPeripheral *peripheral in [PandroBlueToothMeshMgrBridge shareInstance].provisionNodes)
    {
        LampDeviceAddListCellModel *model = [[LampDeviceAddListCellModel alloc] init];
        model.deviceState = DEVICE_MODEL_STATE_CONNECTED;
        model.deviceName = peripheral.name;
        model.peripheralDevice = peripheral;
        
        [self.deviceArray addObject:model];
    }
    
    for (CBPeripheral *peripheral in [PandroBlueToothMeshMgrBridge shareInstance].unprovisionNodes)
    {
        LampDeviceAddListCellModel *model = [[LampDeviceAddListCellModel alloc] init];
        model.deviceState = DEVICE_MODEL_STATE_DEFAULT;
        if(peripheral.name==NULL)
        {
           model.deviceName =[NSString stringWithFormat:@"设备%d",arc4random() % 100];
            NSLog(@"设备名字未获取到 重新获取设备");
            [self.deviceArray removeAllObjects];
            [self.tableView reloadData];
            [[PandroBlueToothMeshMgrOC shareInstance] stopScan];
            [[PandroBlueToothMeshMgrOC shareInstance] startScan];
            return;
        }
        else
        {
            model.deviceName = peripheral.name;
           // printf("%s",peripheral.name);
           // printf("device %s\n",peripheral.identifier.UUIDString);
            NSLog(@"periphera name %@ ",peripheral.name);
            NSLog(@"identify打印输出%@",peripheral.identifier.UUIDString);
        }
        model.peripheralDevice = peripheral;
        [self.deviceArray addObject:model];
        NSLog(@"device array adding %@ %d",peripheral.name,self.deviceArray.count);
    }
    
    
    [self.tableView reloadData];
    
}

//根据选中情况实时调整
-(void)adjustConnectAndGotoBtn
{
    BOOL hasConnected = NO;
    BOOL hasSelected = NO;
    
//    self.selectAllBtn;
      self.connectBtn;
//    self.directGotoBtn;
    
    for (LampDeviceAddListCellModel *deviceModel in self.deviceArray)
    {
        if (deviceModel.deviceState == DEVICE_MODEL_STATE_CONNECTED)
        {
            hasConnected = YES;
        }
        if (deviceModel.deviceState == DEVICE_MODEL_STATE_SELECTED)
        {
            hasSelected = YES;
        }
    }
    
//    if (!hasSelected)
//    {
//        [self.directGotoBtn setHidden:NO];
//        [self bringSubviewToFront:self.directGotoBtn];
//        return;
//    }
    
    [self.connectBtn setHidden:NO];
    [self bringSubviewToFront:self.connectBtn];
}

-(void)clickConnectDevice:(UIButton *)btn
{
    NSMutableArray *willConnectArray = [[NSMutableArray alloc] init];
    /*
    for (LampDeviceAddListCellModel *deviceModel in self.deviceArray)
    {
        if (deviceModel.deviceState == DEVICE_MODEL_STATE_SELECTED)
        {
            if (deviceModel.peripheralDevice)
            {
                [willConnectArray addObject:deviceModel.peripheralDevice];
            }
        }
    }
    */
    
    for (int i=0;i<self.deviceArray.count; i++)
    {
        LampDeviceAddListCellModel *deviceModel = [self.deviceArray objectAtIndex:i];
        if (deviceModel.deviceState == DEVICE_MODEL_STATE_SELECTED)
        {
            [willConnectArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    if (willConnectArray.count == 0) {
        [self showAnimationTip:@"请最少选择一个设备接入" topOffset:0];
        return;

    }else if (willConnectArray.count > 1)
    {
        [self showAnimationTip:@"每次只能选择一个设备接入" topOffset:0];
        return;
    }
    LampDeviceAddViewController *viewCon = [self selfViewController];
    if (viewCon)
    {
        [viewCon clickConnectDevice:willConnectArray];
    }
}

//-(void)clickDirectGoto:(UIButton *)btn
//{
//    LampDeviceAddViewController *viewCon = [self selfViewController];
//    if (viewCon)
//    {
//        [viewCon clickDirectGoto:btn];
//    }
//}

-(void)clickSelectedAllDevice:(UIButton *)btn
{
    checkSelectedAll = !checkSelectedAll;
    
    for (LampDeviceAddListCellModel *deviceModel in self.deviceArray)
    {
        if (deviceModel.deviceState != DEVICE_MODEL_STATE_CONNECTED)
        {
            deviceModel.deviceState = checkSelectedAll?DEVICE_MODEL_STATE_SELECTED:DEVICE_MODEL_STATE_DEFAULT;
        }
    }
    
    [self.tableView reloadData];
    [self adjustConnectAndGotoBtn];
    
    if (checkSelectedAll)
    {
        self.selectAllImgView.image = [UIImage loadImageWithName:@"device_list_device_sel"];
    }
    else
    {
        self.selectAllImgView.image = [UIImage loadImageWithName:@"device_list_device_default"];
    }
    
}

#pragma mark tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    LampDeviceAddListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[LampDeviceAddListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //cell.backgroundColor = [UIColor secondBlackPandroColor];
    }
    
    [cell showContentDevice:[self.deviceArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LampDeviceAddListCell *deviceCell = [tableView cellForRowAtIndexPath:indexPath];
    LampDeviceAddListCellModel *deviceModel = deviceCell.deviceModel;
    
    if (deviceModel.deviceState == DEVICE_MODEL_STATE_DEFAULT)
    {
        deviceModel.deviceState = DEVICE_MODEL_STATE_SELECTED;
        [self.tableView reloadData];
    }
    else if (deviceModel.deviceState == DEVICE_MODEL_STATE_SELECTED)
    {
        deviceModel.deviceState = DEVICE_MODEL_STATE_DEFAULT;
        [self.tableView reloadData];
    }
    
    [self adjustConnectAndGotoBtn];
}


#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(15, 50, self.frame.size.width - 30, self.frame.size.height -170);
        
        CGRect rectImg = CGRectMake(rect.origin.x - 7.5, rect.origin.y - 7.5, rect.size.width + 20, rect.size.height + 20);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rectImg];
        imgView.image = [UIImage loadImageWithName:@"app_table_bg"];
        [self addSubview:imgView];
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.separatorColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self addSubview:_tableView];
    }
    return _tableView;
}

//-(UIControl *)selectAllBtn
//{
//    //全选所有设备
//    if (!_selectAllBtn)
//    {
//        float width = 110;
//        float height = 40;
//        CGRect rect = CGRectMake((self.frame.size.width - width)/2, self.tableView.frame.origin.y + self.tableView.frame.size.height + 10, width, height);
//        _selectAllBtn = [[UIControl alloc] initWithFrame:rect];
//        _selectAllBtn.backgroundColor = [UIColor clearColor];
//        [_selectAllBtn addTarget:self action:@selector(clickSelectedAllDevice:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_selectAllBtn];
//
//        //tip
//        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 18, height)];
//        tipLabel.font = [UIFont systemFontOfSize:14];
//        tipLabel.textColor = [UIColor blackPandroColor];
//        tipLabel.backgroundColor = [UIColor clearColor];
//        tipLabel.text = @"全选所有设备";
//        [_selectAllBtn addSubview:tipLabel];
//
//        //image
//        self.selectAllImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 18, (height - 18)/2, 18, 18)];
//        [_selectAllBtn addSubview:self.selectAllImgView];
//        checkSelectedAll = NO;
//        self.selectAllImgView.image = [UIImage loadImageWithName:@"device_list_device_default"];
//
//
//    }
//    return _selectAllBtn;
//}

-(UIButton *)connectBtn
{
    if (!_connectBtn)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30,CGRectGetMaxY(self.tableView.frame) + 20, self.frame.size.width - 60, 48);
        [btn setBackgroundColor:[UIColor bluePandroColor]];
        [btn setTitle:@"接入" forState:UIControlStateNormal];
        [btn.layer setCornerRadius:10];
        [btn.layer setMasksToBounds:YES];
        [btn addTarget:self action:@selector(clickConnectDevice:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _connectBtn = btn;
        
    }
    return _connectBtn;
}

//-(UIButton *)directGotoBtn
//{
//    if (!_directGotoBtn)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(30, self.selectAllBtn.frame.origin.y + self.selectAllBtn.frame.size.height + 5, self.frame.size.width - 60, 48);
//        [btn setBackgroundColor:[UIColor bluePandroColor]];
//        [btn setTitle:@"直接进入" forState:UIControlStateNormal];
//        [btn.layer setCornerRadius:10];
//        [btn.layer setMasksToBounds:YES];
//        [btn addTarget:self action:@selector(clickDirectGoto:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
//
//        _directGotoBtn = btn;
//
//    }
//
//    return _directGotoBtn;
//}

@end
