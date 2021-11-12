//
//  LampGroupSetDeviceViewController.m
//  Pandro
//
//  Created by chun on 2019/3/2.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "LampGroupSetDeviceViewController.h"
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshDeviceModel.h"
#import "MeshPlaceDatabase.h"
#import "PandroBlueToothMeshMgrOC.h"


@interface LampGroupSetDeviceViewController ()
{
    float sectionHeaderHeight;
    float cellHeight;
}

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)MeshPlaceModel *placeModel;
@property(nonatomic, strong)MeshAreaModel *areaModel;

@property(nonatomic, strong)NSMutableArray *unSeldeviceArray;

@end

@implementation LampGroupSetDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionHeaderHeight = 45;
    cellHeight = 56;
    
    [self showNavBarTitle:@"设备列表"];
    
    [self.view addSubview:self.tableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.pageCommand isEqualToString:@"init"])
    {
        NSString *placeId = [self.pageParams valueForKey:@"placeId"];
        self.placeModel = [[MeshPlaceDatabase shareInstance] placeModelFromPlaceId:placeId];
        
        NSLog(@"== %@", self.placeModel);
        
        NSString *areaId = [self.pageParams valueForKey:@"areaId"];
        for (MeshAreaModel *areaModel in self.placeModel.areaArray)
        {
            if ([areaModel.areaId isEqualToString:areaId])
            {
                self.areaModel = areaModel;
                break;
            }
        }
    }
    
    [self loadContentData];
    
    [self.tableView reloadData];
}

-(void)loadContentData
{
    self.unSeldeviceArray = [[NSMutableArray alloc] init];
    for (MeshDeviceModel *deviceModel in self.placeModel.deviceArray)
    {
        deviceModel.isGroupNum = 0;
        for (MeshAreaModel *areaModel in self.placeModel.areaArray)
        {
            for (MeshDeviceModel *deviceGroupModel in areaModel.deviceArray) {
                if ([deviceModel.deviceId isEqualToString:deviceGroupModel.deviceId]) {
                    deviceModel.isGroupNum += 1;
                    break;
                }
            }
        }
        
        BOOL groupSelect = NO;
        for (MeshDeviceModel *deviceGroupModel in self.areaModel.deviceArray) {
            if ([deviceModel.deviceId isEqualToString:deviceGroupModel.deviceId]) {
                deviceGroupModel.isGroupNum = deviceModel.isGroupNum;
                groupSelect = YES;
                break;
            }
        }
      
        if (!groupSelect){
            [self.unSeldeviceArray addObject:deviceModel];
        }
      
    }
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return sectionHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, sectionHeaderHeight)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, sectionHeaderHeight - 30, self.tableView.frame.size.width, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"A9AEBDFF"];
    [view addSubview:label];
    if (section == 0)
    {
        label.text = @"已添加设备";
    }
    else
    {
        label.text = @"未添加设备";
    }
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return self.unSeldeviceArray.count;
    }
    
    return self.areaModel.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGRect rect = CGRectMake(15, (cellHeight - 20)/2, 15, 20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = 1001;
        [cell addSubview:imageView];
        
        float leftOffset = imageView.frame.origin.x  + imageView.frame.size.width + 15;
        rect = CGRectMake(leftOffset, 0, self.view.frame.size.width -leftOffset -  100, cellHeight);
        UILabel *labelTmp = [[UILabel alloc] initWithFrame:rect];
        labelTmp.backgroundColor = [UIColor clearColor];
        labelTmp.font = [UIFont systemFontOfSize:15];
        labelTmp.textColor = [UIColor blackPandroColor];
        labelTmp.tag = 1002;
        [cell addSubview:labelTmp];
        
        //A9AEBD
        leftOffset = self.tableView.frame.size.width/2;
        float rightOffset = self.tableView.frame.size.width - 15;
        rect = CGRectMake(leftOffset, 0, rightOffset - leftOffset, cellHeight);
        labelTmp = [[UILabel alloc] initWithFrame:rect];
        labelTmp.backgroundColor = [UIColor clearColor];
        labelTmp.font = [UIFont systemFontOfSize:15];
        labelTmp.textAlignment = NSTextAlignmentRight;
        labelTmp.tag = 1003;
        [cell addSubview:labelTmp];
    }
    UIImageView *imgView = [cell viewWithTag:1001];
    
    UILabel *labelNameTag = [cell viewWithTag:1002];
    
    UILabel *labelTip = [cell viewWithTag:1003];

    
    if (indexPath.section == 0)
    {
        imgView.image = [UIImage loadImageWithName:@"group_set_device_sel"];
        MeshDeviceModel *deviceModel = [self.areaModel.deviceArray objectAtIndex:indexPath.row];
        labelNameTag.text = deviceModel.name;
        if (deviceModel.isGroupNum > 0) {
            labelNameTag.text = [NSString stringWithFormat:@"%@(存在%ld个分组中)",deviceModel.name,deviceModel.isGroupNum];
        }
        
        labelTip.text = @"删除";
        labelTip.textColor = [UIColor colorWithHexString:@"F14E4EFF"];
    }
    else
    {
        imgView.image = [UIImage loadImageWithName:@"group_set_device_unsel"];
        
        MeshDeviceModel *deviceModel = [self.unSeldeviceArray objectAtIndex:indexPath.row];
        labelNameTag.text = deviceModel.name;
        if (deviceModel.isGroupNum > 0) {
            labelNameTag.text = [NSString stringWithFormat:@"%@(存在%ld个分组中)",deviceModel.name,deviceModel.isGroupNum];
        }
        
        labelTip.text = @"添加";
        labelTip.textColor = [UIColor colorWithHexString:@"0082FCFF"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //删除
        MeshDeviceModel *selectDeviceModel = [self.areaModel.deviceArray objectAtIndex:indexPath.row];
        [[MeshPlaceDatabase shareInstance] deleteAreaDeviceFromPlace:self.placeModel.placeId areaId:self.areaModel.areaId deviceId:selectDeviceModel.deviceId];
        NSInteger number = 0;
               for (MeshDeviceModel *deviceModel in self.placeModel.deviceArray)
               {
                   if ([selectDeviceModel.deviceId isEqualToString:deviceModel.deviceId]) {
                       [[PandroBlueToothMeshMgrOC shareInstance] deleteDeviceGroupWithNum:number WithName:self.areaModel.name];
                       break;
                   }
                   number++;
               }
    }
    else
    {
        //添加
        MeshDeviceModel *selectDeviceModel = [self.unSeldeviceArray objectAtIndex:indexPath.row];
        [[MeshPlaceDatabase shareInstance] addAreaDeviceFromPlace:self.placeModel.placeId areaId:self.areaModel.areaId deviceId:selectDeviceModel.deviceId];
        NSInteger number = 0;
        for (MeshDeviceModel *deviceModel in self.placeModel.deviceArray)
        {
            if ([selectDeviceModel.deviceId isEqualToString:deviceModel.deviceId]) {
                [[PandroBlueToothMeshMgrOC shareInstance] addDeviceGroupWithNum:number WithName:self.areaModel.name];
                break;
            }
            number++;
        }
    }
    
    [self loadContentData];
    [self.tableView reloadData];
}

#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(15, self.navBar.frame.size.height, self.view.frame.size.width-30, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor littleGrayPandroColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.layer.shadowColor = [UIColor bluePandroColor].CGColor;
        _tableView.layer.shadowOffset = CGSizeMake(5, 5);
        _tableView.layer.shadowRadius = 2;
        _tableView.layer.shadowOpacity = 0.2;
        
    }
    return _tableView;
}


@end
