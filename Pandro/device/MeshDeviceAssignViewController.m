//
//  MeshDeviceAssignViewController.m
//  Pandro
//
//  Created by chun on 2019/1/8.
//  Copyright © 2019年 chun. All rights reserved.
//

#import "MeshDeviceAssignViewController.h"
#import "MeshDeviceAsignCell.h"
#import "MeshPlaceModel.h"
#import "MeshAreaModel.h"
#import "MeshPlaceDatabase.h"


@interface MeshDeviceAssignViewController ()

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)MeshPlaceModel *placeModel;
@property(nonatomic, strong)MeshAreaModel *areaModel;

@end

@implementation MeshDeviceAssignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self processCommand:self.pageCommand params:self.pageParams];
    
}

-(void)processCommand:(NSString *)command params:(NSDictionary *)params
{
    if ([command isEqualToString:@"init"])
    {
        MeshPlaceModel *placeModel = [[MeshPlaceDatabase shareInstance] placeModelFromPlaceId:[params valueForKey:@"placeId"]];
        if (!placeModel)
        {
            return;
        }
        self.placeModel = placeModel;
        for (MeshAreaModel *areaModel in placeModel.areaArray)
        {
        if ([areaModel.areaId isEqualToString:[params valueForKey:@"areaId"]])
            {
                self.areaModel = areaModel;
                break;
            }
        }
        [self.tableView reloadData];
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

#pragma mark click


#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeModel.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    MeshDeviceAsignCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[MeshDeviceAsignCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
    }
    cell.areaModel = self.areaModel;
    [cell showContentFromModel:[self.placeModel.deviceArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MeshDeviceModel *deviceModel = [self.placeModel.deviceArray objectAtIndex:indexPath.row];
    if ([self.areaModel checkContainDevice:deviceModel])
    {
        [self.areaModel.deviceArray removeObject:deviceModel];
    }
    else
    {
        [self.areaModel.deviceArray addObject:deviceModel];
    }
    
    [[MeshPlaceDatabase shareInstance] savaDatabase];
    
    MeshDeviceAsignCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell showContentFromModel:[self.placeModel.deviceArray objectAtIndex:indexPath.row]];
    
}

#pragma mark setter and getter
-(UITableView *)tableView
{
    if (!_tableView)
    {
        CGRect rect = CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
