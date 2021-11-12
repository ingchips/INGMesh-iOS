//
//  MeshPlaceListViewController.m
//  Pandro
//
//  Created by chun on 2018/12/20.
//  Copyright © 2018年 chun. All rights reserved.
//

#import "MeshPlaceListViewController.h"
#import "MeshMainControlMenuView.h"
#import "MeshPlaceDatabase.h"
#import "MeshPlaceListCell.h"

@interface MeshPlaceListViewController ()

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIButton *addBtnView;

@end

@implementation MeshPlaceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarTitle:@"first"];
    
    
    UIImage *image = [UIImage loadImageWithName:@"ic_menu"];
    [self.navBar.leftBtn setImage:image forState:UIControlStateNormal];
    
    [[MeshPlaceDatabase shareInstance] refreshDatabase];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.addBtnView];
    [self.addBtnView addTarget:self action:@selector(clickAddPlace:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickLeftBtn
{
    [MeshMainControlMenuView showMenuViewInView:self.view];
}

-(void)clickAddPlace:(id)sender
{
    [self gotoPage:PAGE_PLACE_ADD_VIEWCONTROLLER params:nil command:@"init"];
}


#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MeshPlaceDatabase shareInstance].placeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierForCell = @"identifierForCell";
    MeshPlaceListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierForCell];
    if (!cell)
    {
        cell = [[MeshPlaceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierForCell];
    }
    
    [cell showContentFromModel:[[MeshPlaceDatabase shareInstance].placeArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MeshPlaceModel *placeModel = [[MeshPlaceDatabase shareInstance].placeArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:placeModel.placeId forKey:@"placeId"];
    [self gotoPage:PAGE_AREA_LIST_VIEWCONTROLLER params:dict command:@"init"];
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

-(UIButton *)addBtnView
{
    if (!_addBtnView)
    {
        CGRect rect = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 180, 50, 50);
        _addBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtnView.frame = rect;
        [_addBtnView setImage:[UIImage loadImageWithName:@"ic_add"] forState:UIControlStateNormal];
        [_addBtnView addTarget:self action:@selector(clickAddPlace:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtnView;
    
}


@end
